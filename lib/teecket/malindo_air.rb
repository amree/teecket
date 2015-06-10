class MalindoAir < Flight
  def get
    new_date = DateTime.parse(date)
    new_date = new_date.strftime('%Q')

    uri = URI('https://mobileapi.malindoair.com/GQWCF_FlightEngine/GQDPMobileBookingService.svc/InitializeGQService')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' => 'application/json' })
    req.body = '{"B2BID":"0","UserLoginId":"0","CustomerUserID":91,"Language":"en-GB","isearchType":"15"}'

    res = http.request(req)
    key = res['wscContext']

    if key
      uri = URI('https://mobileapi.malindoair.com/GQWCF_FlightEngine/GQDPMobileBookingService.svc/SearchAirlineFlights')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' => 'application/json',
                                                         'WscContext'   => key })

      payload = "{\"sd\":{\"Adults\":1,\"AirlineCode\":\"\",\"ArrivalCity\":\"#{to}\",\"ArrivalCityName\":null,\"BookingClass\":null,\"CabinClass\":0,\"ChildAge\":[],\"Children\":0,\"CustomerId\":0,\"CustomerType\":0,\"CustomerUserId\":91,\"DepartureCity\":\"#{from}\",\"DepartureCityName\":null,\"DepartureDate\":\"/Date(#{new_date})/\",\"DepartureDateGap\":0,\"DirectFlightsOnly\":false,\"Infants\":0,\"IsPackageUpsell\":false,\"JourneyType\":1,\"ReturnDate\":\"/Date(-2208988800000)/\",\"ReturnDateGap\":0,\"SearchOption\":1},\"fsc\":\"0\"}"

      req.body = payload

      res = http.request(req)

      result = JSON.parse(res.body)

      if result['SearchAirlineFlightsResult']
        result['SearchAirlineFlightsResult'].each do |rs|
          depart_at     = rs['DepartureDate']
          arrive_at     = rs['ArrivalDate']
          fare          = rs['FlightAmount']
          flight_number = rs['MACode'] + rs['FlightNo']
          origin        = rs['DepCity']
          destination   = rs['ArrCity']

          depart_at     = DateTime.strptime(depart_at.gsub(/^\/Date\(|\)\//, ''), '%Q').strftime('%I:%M %p')
          arrive_at     = DateTime.strptime(arrive_at.gsub(/^\/Date\(|\)\//, ''), '%Q').strftime('%I:%M %p')
          fare          = sprintf("%.2f", fare)

          fares << { flight_name: 'Malindo Air',
                     flight_number: flight_number,
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
