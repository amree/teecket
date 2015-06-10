class MalaysiaAirlines < Flight
  def get
    new_date = DateTime.parse(date)
    new_date = new_date.strftime('%Y-%m-%d')

    uri = URI("https://flymh.mobi/TravelAPI/travelapi/shop/1/mh/#{from}/#{to}/1/0/0/Economy/#{new_date}/")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.path, initHeader = { 'X-apiKey' => '52e6d6d613d3a3e825ac02253fe6b5a4'})

    res = http.request(req)
    res.body.gsub!(/^fn\(/, '')
    res.body.gsub!(/\)/, '')

    result = JSON.parse(res.body)

    if result['success']
      result['outboundOptions'].each do |rs|
        depart_at     = DateTime.parse(rs['flights'][0]['depScheduled'])
        arrive_at     = DateTime.parse(rs['flights'][0]['arrScheduled'])
        fare          = rs['fareDetails']['totalTripFare']
        flight_number = rs['flights'][0]['marketingAirline'] + rs['flights'][0]['flightNumber']
        origin        = rs['flights'][0]['departureAirport']['code']
        destination   = rs['flights'][0]['arrivalAirport']['code']

        depart_at = depart_at.strftime('%I:%M %p')
        arrive_at = arrive_at.strftime('%I:%M %p')
        fare      = sprintf("%.2f", fare)

          fares << { flight_name: 'Malaysia Airlines',
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
