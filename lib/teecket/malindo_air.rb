class MalindoAir < Flight
  include PageRequester

  attr_accessor :res, :new_date

  def search
    get
    process
  end

  private

  def prepare
    self.new_date = DateTime.parse(date)
    self.new_date = new_date.strftime("%Q")
  end

  def get
    get_initialization_page
    get_result_page
  end

  def get_initialization_page
    prepare

    url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" <<
          "GQDPMobileBookingService.svc/InitializeGQService"

    uri = URI(url)

    req = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
    req.body = '{"B2BID":"0","UserLoginId":"0","CustomerUserID":91,' <<
      '"Language":"en-GB","isearchType":"15"}'

    self.res = request(uri, req)
  end

  def get_result_page
    key = res["wscContext"]

    url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" <<
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

    flights_count(json).each do |elem|
      params = if trips(elem).count > 1
                 process_for_transit(elem)
               else
                 process_for_non_transit(elem)
               end

      process_for_all(elem, params)
    end
  end

  def trips(elem)
    elem["SegmentInformation"]
  end

  def process_for_transit(elem)
    trips = trips(elem)
    arrive_at = arrive_at_selector(trips[trips.size - 1]["ArrivalDate"])

    { transit: "YES", arrive_at: arrive_at }
  end

  def process_for_non_transit(elem)
    arrive_at = arrive_at_selector(elem["ArrivalDate"])

    { transit: "NO", arrive_at: arrive_at }
  end

  def process_for_all(elem, params)
    depart_at = depart_at_selector(elem)
    fare = fare_selector(elem)
    origin = origin_selector(elem)
    destination = destination_selector(elem)
    flight_number = flight_number_selector(elem)

    add_to_fares(flight_name: "Malindo Air",
                 flight_number: flight_number,
                 transit: params[:transit],
                 origin: origin,
                 destination: destination,
                 depart_at: depart_at,
                 arrive_at: params[:arrive_at],
                 fare: fare)
  end

  def payload
    "{\"sd\":{\"Adults\":1,\"AirlineCode\":\"\"," <<
      "\"ArrivalCity\":\"#{to}\",\"ArrivalCityName\":null," <<
      "\"BookingClass\":null,\"CabinClass\":0,\"ChildAge\":[]," <<
      "\"Children\":0,\"CustomerId\":0,\"CustomerType\":0," <<
      "\"CustomerUserId\":91,\"DepartureCity\":\"#{from}\"," <<
      "\"DepartureCityName\":null," <<
      "\"DepartureDate\":\"/Date(#{new_date})/\"," <<
      "\"DepartureDateGap\":0,\"DirectFlightsOnly\":false," <<
      "\"Infants\":0,\"IsPackageUpsell\":false,\"JourneyType\":1," <<
      "\"ReturnDate\":\"/Date(-2208988800000)/\"," <<
      "\"ReturnDateGap\":0,\"SearchOption\":1},\"fsc\":\"0\"}"
  end

  def flights_count(result)
    result["SearchAirlineFlightsResult"]
  end

  def depart_at_selector(elem)
    depart_arrive_at_formatter(elem["DepartureDate"])
  end

  def arrive_at_selector(elem)
    depart_arrive_at_formatter(elem)
  end

  def fare_selector(elem)
    fare_formatter(elem["FlightAmount"])
  end

  def flight_number_selector(elem)
    elem["SegmentInformation"].map do |trip|
      trip["MACode"] + trip["FlightNo"]
    end.join(" + ")
  end

  def origin_selector(elem)
    elem["DepCity"]
  end

  def destination_selector(elem)
    elem["ArrCity"]
  end

  def depart_arrive_at_formatter(datetime)
    DateTime
      .strptime(datetime.gsub(%r(^\/Date\(|\)\/), ""), "%Q")
      .strftime("%I:%M %p")
  end

  def fare_formatter(fare)
    sprintf("%.2f", fare)
  end
end
