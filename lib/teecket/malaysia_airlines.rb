# encoding: utf-8
class MalaysiaAirlines < Flight
  def get
    new_date = DateTime.parse(date)
    new_date = new_date.strftime("%Y-%m-%d")

    uri = URI("https://flymh.mobi/TravelAPI/travelapi/shop/1/mh/#{from}/#{to}/1/0/0/Economy/#{new_date}/")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.path, initHeader = { "X-apiKey" => "52e6d6d613d3a3e825ac02253fe6b5a4" })

    res = http.request(req)
    res.body.gsub!(/^fn\(/, "")
    res.body.gsub!(/\)/, "")

    result = JSON.parse(res.body)

    if result["success"]
      result["outboundOptions"].each do |rs|
        fare = rs["fareDetails"]["totalTripFare"]
        origin = rs["flights"][0]["departureAirport"]["code"]
        depart_at = rs["flights"][0]["depScheduled"]

        if rs["flights"].count > 1
          transit = "YES"
          arrive_at = rs["flights"][rs["flights"].count - 1]["arrScheduled"]
          flight_number = rs["flights"].map { |arr| arr["operatingAirline"] + arr["flightNumber"] }.join(" + ")
          destination = rs["flights"][rs["flights"].count - 1]["arrivalAirport"]["code"]
        else
          transit = "NO"
          arrive_at = rs["flights"][0]["arrScheduled"]
          flight_number = rs["flights"][0]["marketingAirline"] + rs["flights"][0]["flightNumber"]
          destination = rs["flights"][0]["arrivalAirport"]["code"]
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
