class MalindoAir < Flight
  include PageRequester

  def get
    new_date = DateTime.parse(date)
    new_date = new_date.strftime("%Q")

    url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" <<
          "GQDPMobileBookingService.svc/InitializeGQService"

    uri = URI(url)

    req = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
    req.body = '{"B2BID":"0","UserLoginId":"0","CustomerUserID":91,' <<
      '"Language":"en-GB","isearchType":"15"}'

    res = request(uri, req)
    key = res["wscContext"]

    if key
      url = "https://mobileapi.malindoair.com/GQWCF_FlightEngine/" <<
            "GQDPMobileBookingService.svc/SearchAirlineFlights"

      uri = URI(url)

      req = Net::HTTP::Post.new(uri.path,
                                "Content-Type" => "application/json",
                                "WscContext" => key)

      payload = "{\"sd\":{\"Adults\":1,\"AirlineCode\":\"\"," <<
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

      req.body = payload

      res = request(uri, req)

      result = JSON.parse(res.body)

      if result["SearchAirlineFlightsResult"]
        result["SearchAirlineFlightsResult"].each do |rs|
          main_path = rs["SegmentInformation"]
          flight_count = main_path.count

          if flight_count > 1
            transit = "YES"
            arrive_at = main_path[flight_count - 1]["ArrivalDate"]
          else
            transit = "NO"
            arrive_at = rs["ArrivalDate"]
          end

          depart_at = rs["DepartureDate"]
          fare = rs["FlightAmount"]
          origin = rs["DepCity"]
          destination = rs["ArrCity"]

          flight_number = main_path.map do |arr|
            arr["MACode"] + arr["FlightNo"]
          end.join(" + ")

          depart_at = DateTime
                      .strptime(depart_at.gsub(%r(^\/Date\(|\)\/), ""), "%Q")
                      .strftime("%I:%M %p")

          arrive_at = DateTime
                      .strptime(arrive_at.gsub(%r(^\/Date\(|\)\/), ""), "%Q")
                      .strftime("%I:%M %p")

          fare = sprintf("%.2f", fare)

          fares << { flight_name: "Malindo Air",
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
end
