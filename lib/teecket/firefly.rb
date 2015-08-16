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
    uri = URI("http://fireflymobile.me-tech.com.my/fylive3/search.php")

    req = Net::HTTP::Get.new(uri.path)

    self.res = request(uri, req, false)

    self.cookie = res["Set-Cookie"]
  end

  def get_search_page
    uri = URI("http://fireflymobile.me-tech.com.my/fylive3/search.php")

    date_object = Date.strptime(date, "%d-%m-%Y")
    date_year = date_object.strftime("%Y")
    date_month = date_object.strftime("%m")
    date_day = date_object.strftime("%d")

    req = Net::HTTP::Post.new(uri.path, "Cookie" => cookie)
    req.body = URI.encode_www_form([
      ["action", "search"],
      ["type", 2],
      ["departing", from],
      ["arriving", to],
      ["d10", date_day],
      ["d11", date_month],
      ["d12", date_year],
      ["departuredate", date],
      ["d20", date_day],
      ["d21", date_month],
      ["d22", date_year],
      ["returndate", date],
      ["adult", 1],
      ["infant", 0]
    ])

    self.res = request(uri, req, false)
  end

  def get_result_page
    if res["location"]
      uri = URI("http://fireflymobile.me-tech.com.my/fylive3/" + res["location"])

      req = Net::HTTP::Get.new(uri.path, "Cookie" => cookie)

      self.res = request(uri, req, false)
    end
  end

  def process
    html = Nokogiri::HTML(res.body)

    origin, destination = origin_destination_selector(html)

    flights(html).each_with_index do |flight, i|
      next if i == 0

      depart_at = depart_at_selector(flight)
      arrive_at = arrive_at_selector(flight)
      fare = fare_selector(flight)
      flight_number = flight_number_selector(flight)
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
    data.css("form table:last tr")
  end
end
