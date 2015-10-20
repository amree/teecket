class MalindoAir < Flight
  include PageRequester
  include Selectors::MalindoAir

  attr_accessor :res

  private

  def prepare
    self.date = date.strftime("%Q")
    self.from = from.upcase
    self.to = to.upcase
  end

  def get
    get_initialization_page
    get_result_page
  end

  def get_initialization_page
    prepare

    url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" \
          "GQDPMobileBookingService.svc/InitializeGQService"

    uri = URI(url)

    req = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
    req.body = '{"B2BID":"0","UserLoginId":"0","CustomerUserID":91,' \
      '"Language":"en-GB","isearchType":"15"}'

    self.res = request(uri, req)
  end

  def get_result_page
    key = res["wscContext"]

    url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" \
          "GQDPMobileBookingService.svc/SearchAirlineFlights"

    uri = URI(url)

    req = Net::HTTP::Post.new(uri.path,
                              "Content-Type" => "application/json",
                              "WscContext" => key)

    req.body = payload
    self.res = request(uri, req)
  end

  def process
    json = JSON.parse(res.body)
    return unless flights(json)

    flights(json).each do |flight|
      params = if trips(flight).count > 1
                 process_for_transit(flight)
               else
                 process_for_non_transit(flight)
               end
      process_for_all(flight, params)
    end
  end

  def trips(flight)
    flight["SegmentInformation"]
  end

  def process_for_transit(flight)
    trips = trips(flight)
    arrive_at = arrive_at_selector(trips[trips.size - 1]["ArrivalDate"])

    { transit: "YES", arrive_at: arrive_at }
  end

  def process_for_non_transit(flight)
    arrive_at = arrive_at_selector(flight["ArrivalDate"])

    { transit: "NO", arrive_at: arrive_at }
  end

  def process_for_all(flight, params)
    depart_at = depart_at_selector(flight)
    fare = fare_selector(flight)
    origin = origin_selector(flight)
    destination = destination_selector(flight)
    flight_number = flight_number_selector(flight)

    if params[:transit] == "NO"
      add_to_fares(flight_name: "Malindo Air",
                   flight_number: flight_number,
                   transit: params[:transit],
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: params[:arrive_at],
                   fare: fare)
    end
  end

  def payload
    "{\"sd\":{\"Adults\":1,\"AirlineCode\":\"\"," \
      "\"ArrivalCity\":\"#{to}\",\"ArrivalCityName\":null," \
      "\"BookingClass\":null,\"CabinClass\":0,\"ChildAge\":[]," \
      "\"Children\":0,\"CustomerId\":0,\"CustomerType\":0," \
      "\"CustomerUserId\":91,\"DepartureCity\":\"#{from}\"," \
      "\"DepartureCityName\":null," \
      "\"DepartureDate\":\"/Date(#{date})/\"," \
      "\"DepartureDateGap\":0,\"DirectFlightsOnly\":false," \
      "\"Infants\":0,\"IsPackageUpsell\":false,\"JourneyType\":1," \
      "\"ReturnDate\":\"/Date(-2208988800000)/\"," \
      "\"ReturnDateGap\":0,\"SearchOption\":1},\"fsc\":\"0\"}"
  end

  def flights(result)
    result["SearchAirlineFlightsResult"]
  end
end
