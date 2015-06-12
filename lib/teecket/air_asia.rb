# encoding: utf-8
class AirAsia < Flight
  def get
    uri = URI("https://argon.airasia.com/api/7.0/search")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.body = URI.encode_www_form([
      ["type", "classic"],
      ["origin", from],
      ["destination", to],
      ["depart", date],
      ["return", ""],
      ["passenger-count", 1],
      ["child-count", 0],
      ["infant-count", 0],
      ["currency", "MYR"],
      ["days", 1]
    ])

    res = http.request(req)

    result = JSON.parse(res.body)

    if result["session-id"]
      begin
        result["depart"][date]["details"]["low-fare"].each do |rs|
          depart_at = DateTime.parse(rs["segments"][0]["departure-datetime"])
          arrive_at = DateTime.parse(rs["segments"][0]["arrival-datetime"])
          fare = rs["total"]["adult"]
          flight_number = rs["segments"][0]["flight-number"]
          origin = rs["segments"][0]["origincode"]
          destination = rs["segments"][0]["destinationcode"]
          transit = "NO"

          depart_at = depart_at.strftime("%I:%M %p")
          arrive_at = arrive_at.strftime("%I:%M %p")
          fare = sprintf("%.2f", fare)
          flight_number = flight_number.gsub(/ /, "")

          fares << { flight_name: "AirAsia",
                     flight_number: flight_number,
                     transit: transit,
                     origin: origin,
                     destination: destination,
                     depart_at: depart_at,
                     arrive_at: arrive_at,
                     fare: fare }
        end
      rescue StandardError
      end
    end
  end
end
