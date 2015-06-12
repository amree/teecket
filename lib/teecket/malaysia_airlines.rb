class MalaysiaAirlines < Flight
  include PageRequester

  def get
    new_date = DateTime.parse(date)
    new_date = new_date.strftime("%Y-%m-%d")

    key = "52e6d6d613d3a3e825ac02253fe6b5a4"
    url = "https://flymh.mobi/TravelAPI/travelapi/shop/1/mh/" <<
          "#{from}/#{to}/1/0/0/Economy/#{new_date}/"

    uri = URI(url)

    req = Net::HTTP::Get.new(uri.path, "X-apiKey" => key)

    res = request(uri, req)

    res.body.gsub!(/^fn\(/, "")
    res.body.gsub!(/\)/, "")

    result = JSON.parse(res.body)

    if result["success"]
      result["outboundOptions"].each do |rs|
        flights = rs["flights"]
        fare = rs["fareDetails"]["totalTripFare"]
        origin = flights[0]["departureAirport"]["code"]
        depart_at = flights[0]["depScheduled"]

        total_flights = flights.count
        if flights.count > 1
          curr_flight = total_flights - 1

          transit = "YES"
          arrive_at = flights[curr_flight]["arrScheduled"]

          flight_number = flights.map do |arr|
            arr["operatingAirline"] + arr["flightNumber"]
          end.join(" + ")

          destination = flights[curr_flight]["arrivalAirport"]["code"]
        else
          curr_flight = flights[0]

          transit = "NO"
          arrive_at = curr_flight["arrScheduled"]
          flight_number =
            curr_flight["marketingAirline"] + curr_flight["flightNumber"]
          destination = curr_flight["arrivalAirport"]["code"]
        end

        depart_at = DateTime.parse(depart_at).strftime("%I:%M %p")
        arrive_at = DateTime.parse(arrive_at).strftime("%I:%M %p")
        fare = sprintf("%.2f", fare)

        fares << { flight_name: "Malaysia Airlines",
                   flight_number: flight_number,
                   transit: transit,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare }
      end
    end
  end
end
