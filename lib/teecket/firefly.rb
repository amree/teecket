require "nokogiri"

class Firefly < Flight
  include PageRequester
  include Selectors::Firefly

  attr_accessor :res, :cookie

  private

  def formatted_date
    "#{date.mday}-#{date.strftime('%m')}-#{date.strftime('%y')}"
  end

  def get
    get_cookie
    do_search
    get_result_page
  end

  def get_cookie
    uri = URI("http://fireflymobile.me-tech.com.my/fylive3/search.php")

    req = Net::HTTP::Get.new(uri.path)

    self.res = request(uri, req, false)

    self.cookie = res["Set-Cookie"].split(";")[0]
  end

  def do_search
    uri = URI("http://fireflymobile.me-tech.com.my/fylive3/search.php")

    day   = date.mday
    month = date.strftime("%m")
    year  = date.strftime("%y")

    req = Net::HTTP::Post.new(uri.path, "Cookie" => cookie)
    req.body = URI.encode_www_form(
      [
        ["action", "search"],
        ["type", 2],
        ["departing", from],
        ["arriving", to],
        ["d10", day],
        ["d11", month],
        ["d12", year],
        ["departuredate", formatted_date],
        ["d20", day],
        ["d21", month],
        ["d22", year],
        ["returndate", formatted_date],
        ["adult", 1],
        ["infant", 0]
      ]
    )

    self.res = request(uri, req, false)
  end

  def get_result_page
    if res.code == "302"
      uri = URI("http://fireflymobile.me-tech.com.my/fylive3/" +
              res["location"])

      req = Net::HTTP::Get.new(uri.path, "Cookie" => cookie)

      self.res = request(uri, req, false)
    end
  end

  def process
    html = Nokogiri::HTML(res.body)

    if html.children.count <= 1
      return
    end

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
