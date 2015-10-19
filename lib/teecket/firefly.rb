require "nokogiri"

class Firefly < Flight
  include PageRequester
  include Selectors::Firefly

  attr_accessor :res, :cookie

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

  def split_date(date_object)
    date_object = Date.strptime(date, "%d-%m-%Y")
    [
      date_object.strftime("%d"),
      date_object.strftime("%m"),
      date_object.strftime("%Y")
    ]
  end

  # rubocop:disable Metrics/AbcSize
  def get_search_page
    uri = URI("http://fireflymobile.me-tech.com.my/fylive3/search.php")

    day, month, year = split_date(Date.strptime(date, "%d-%m-%Y"))

    req = Net::HTTP::Post.new(uri.path, "Cookie" => cookie)
    req.body = URI.encode_www_form([
      ["action", "search"],
      ["type", 2],
      ["departing", from],
      ["arriving", to],
      ["d10", day],
      ["d11", month],
      ["d12", year],
      ["departuredate", date],
      ["d20", day],
      ["d21", month],
      ["d22", year],
      ["returndate", date],
      ["adult", 1],
      ["infant", 0]
    ])

    self.res = request(uri, req, false)
  end

  def get_result_page
    if res["location"]
      uri = URI("http://fireflymobile.me-tech.com.my/fylive3/" +
              res["location"])

      req = Net::HTTP::Get.new(uri.path, "Cookie" => cookie)

      self.res = request(uri, req, false)
    end
  end

  def process
    html = Nokogiri::HTML(res.body)

    origin, destination = origin_destination_selector(html)

    flights(html).each_with_index do |flight, index|
      next if index == 0
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
