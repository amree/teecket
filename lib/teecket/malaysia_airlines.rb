class MalaysiaAirlines < Flight
  include PageRequester
  include Selectors::MalaysiaAirlines

  attr_accessor :res

  private

  # yyyy-mm-dd
  def formatted_date
    "#{date.year}-#{date.mon}-#{date.mday}"
  end

  def get
    key = "52e6d6d613d3a3e825ac02253fe6b5a4"
    url = "https://flymh.mobi/TravelAPI/travelapi/shop/1/mh/" \
          "#{from}/#{to}/1/0/0/Economy/#{formatted_date}/"

    uri = URI(url)

    req = Net::HTTP::Get.new(uri.path, "X-apiKey" => key)

    self.res = request(uri, req)
  end

  def process
    json = JSON.parse res.body.gsub(/^fn\(|\)/, "")

    flights(json).each do |flight|
      params = if flight["flights"].count > 1
                 process_for_transit(flight)
               else
                 process_for_non_transit(flight)
               end

      process_for_all(flight, params)
    end
  end

  def process_for_transit(flight)
    trips = flight["flights"]

    transit = "YES"
    arrive_at = arrive_at_selector(trips[trips.count - 1])
    flight_number = flight_number_selector(trips, true)
    destination = destination_selector(trips[trips.count - 1])

    { transit: transit,
      arrive_at: arrive_at,
      flight_number: flight_number,
      destination: destination }
  end

  def process_for_non_transit(flight)
    trips = flight["flights"]

    transit = "NO"
    arrive_at = arrive_at_selector(trips[0])
    flight_number = flight_number_selector(trips[0], false)
    destination = destination_selector(trips[0])

    { transit: transit,
      arrive_at: arrive_at,
      flight_number: flight_number,
      destination: destination }
  end

  def process_for_all(flight, params)
    trips = flight["flights"]

    fare = fare_selector(flight)
    origin = origin_selector(trips[0])
    depart_at = depart_at_selector(trips[0])

    add_to_fares(flight_name: "Malaysia Airlines",
                 flight_number: params[:flight_number],
                 transit: params[:transit],
                 origin: origin,
                 destination: params[:destination],
                 depart_at: depart_at,
                 arrive_at: params[:arrive_at],
                 fare: fare)
  end

  def flights(result)
    result["outboundOptions"]
  end
end
