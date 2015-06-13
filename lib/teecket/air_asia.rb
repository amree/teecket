class AirAsia < Flight
  include PageRequester

  attr_accessor :res

  def search
    get
    process
  rescue StandardError
  end

  private

  def get
    uri = URI("https://argon.airasia.com/api/7.0/search")

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

  def depart_at_selector(flight)
    depart_arrivate_at_formatter(flight["segments"][0]["departure-datetime"])
  end

  def arrive_at_selector(flight)
    depart_arrivate_at_formatter(flight["segments"][0]["arrival-datetime"])
  end

  def fare_selector(flight)
    fare_formatter(flight["total"]["adult"])
  end

  def flight_number_selector(flight)
    flight_number_formatter(flight["segments"][0]["flight-number"])
  end

  def origin_selector(flight)
    flight["segments"][0]["origincode"]
  end

  def destination_selector(flight)
    flight["segments"][0]["destinationcode"]
  end

  def depart_arrivate_at_formatter(datetime)
    DateTime.parse(datetime).strftime("%I:%M %p")
  end

  def fare_formatter(fare)
    sprintf("%.2f", fare)
  end

  def flight_number_formatter(flight_number)
    flight_number.gsub(/ /, "")
  end
end
