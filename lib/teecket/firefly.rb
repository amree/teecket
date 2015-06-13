require "nokogiri"

class Firefly < Flight
  include PageRequester

  attr_accessor :res, :cookie

  def search
    get
    process
  rescue StandardError
  end

  private

  def get
    get_main_page
    get_search_page
    get_result_page
  end

  def get_main_page
    uri = URI("https://m.fireflyz.com.my/")

    req = Net::HTTP::Get.new(uri.path)

    self.res = request(uri, req)

    self.cookie = res["Set-Cookie"]
  end

  def get_search_page
    uri = URI("https://m.fireflyz.com.my/Search")

    req = Net::HTTP::Post.new(uri.path, "Cookie" => cookie)
    req.body = URI.encode_www_form([
      ["type", 2],
      ["return_date", date],
      ["adult", 1],
      ["infant", 0],
      ["departure_station", from],
      ["arrival_station", to],
      ["departure_date", date]
    ])

    self.res = request(uri, req)
  end

  def get_result_page
    if res["location"]
      uri = URI(res["location"])

      req = Net::HTTP::Get.new(uri.path, "Cookie" => cookie)

      self.res = request(uri, req)
    end
  end

  def process
    html = Nokogiri::HTML(res.body)

    flights(html).each do |flight|
      depart_at = depart_at_selector(flight)
      arrive_at = arrive_at_selector(flight)
      fare = fare_selector(flight)
      flight_number = flight_number_selector(flight)
      origin = origin_selector(flight)
      destination = destination_selector(flight)
      transit = "NO"

      add_to_fares(flight_name: "Firefly",
                   flight_number: flight_number,
                   transit: transit,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare)
    end
  end

  def flights(data)
    data.css("div.market1")
  end

  def depart_at_selector(flight)
    value = flight
            .css("div.visible-xs")
            .css("table")[1]
            .css("td")[0]

    depart_arrive_at_formatter(value)
  end

  def arrive_at_selector(flight)
    value = flight
            .css("div.visible-xs")
            .css("table")[1]
            .css("td")[1]

    depart_arrive_at_formatter(value)
  end

  def fare_selector(flight)
    value = flight
            .css("div.visible-xs > div")

    fare_formatter(value)
  end

  def flight_number_selector(flight)
    value = flight
            .css("div.visible-xs")
            .css("table")[0]

    flight_number_formatter(value)
  end

  def origin_selector(flight)
    flight["onclick"]
      .scan(/~[A-Z]{3}~/)[0]
      .gsub("~", "")
  end

  def destination_selector(flight)
    flight["onclick"]
      .scan(/~[A-Z]{3}~/)[1]
      .gsub("~", "")
  end

  def depart_arrive_at_formatter(datetime)
    datetime = datetime.text.strip.gsub(/\t/, "").match(/^(.*?)(AM|PM)/)[0]
    DateTime.parse("#{date} #{datetime}").strftime("%I:%M %p")
  end

  def fare_formatter(fare)
    fare.text.strip.gsub(/ MYR/, "")
  end

  def flight_number_formatter(flight_number)
    flight_number.text.strip.gsub(/ /, "").gsub(/FLIGHTNO\./, "")
  end
end
