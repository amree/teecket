class AirAsia < Flight
  include PageRequester
  include Selectors::AirAsia

  attr_accessor :res

  private

  def get
    uri = URI("https://argon.airasia.com/api/7.0/search")

    req = Net::HTTP::Post.new(uri.path)
    req.add_field("Channel", "mobile-touch-app")

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
      ["days", 1],
      ["promo-code", ""]
    ])

    self.res = request(uri, req)
  end

  def process
    json = JSON.parse(res.body)

    flights(json).each do |flight|
      depart_at = depart_at_selector(flight)
      arrive_at = arrive_at_selector(flight)
      fare = fare_selector(flight)
      flight_number = flight_number_selector(flight)
      origin = origin_selector(flight)
      destination = destination_selector(flight)
      transit = "NO"

      add_to_fares(flight_name: "AirAsia",
                   flight_number: flight_number,
                   transit: transit,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare)
    end
  end

  def flights(result)
    if result["session-id"]
      result["depart"][date]["details"]["low-fare"]
    else
      []
    end
  end
end
