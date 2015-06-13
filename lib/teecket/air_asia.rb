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

    flights_count(json).each do |elem|
      depart_at = depart_at_selector(elem)
      arrive_at = arrive_at_selector(elem)
      fare = fare_selector(elem)
      flight_number = flight_number_selector(elem)
      origin = origin_selector(elem)
      destination = destination_selector(elem)
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

  def flights_count(result)
    if result["session-id"]
      result["depart"][date]["details"]["low-fare"]
    else
      []
    end
  end

  def depart_at_selector(elem)
    depart_arrivate_at_formatter(elem["segments"][0]["departure-datetime"])
  end

  def arrive_at_selector(elem)
    depart_arrivate_at_formatter(elem["segments"][0]["arrival-datetime"])
  end

  def fare_selector(elem)
    fare_formatter(elem["total"]["adult"])
  end

  def flight_number_selector(elem)
    flight_number_formatter(elem["segments"][0]["flight-number"])
  end

  def origin_selector(elem)
    elem["segments"][0]["origincode"]
  end

  def destination_selector(elem)
    elem["segments"][0]["destinationcode"]
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
