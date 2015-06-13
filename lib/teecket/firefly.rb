require "nokogiri"

class Firefly < Flight
  include PageRequester
  include Selectors::Firefly

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
end
