require "nokogiri"

class Firefly < Flight
  include PageRequester

  attr_accessor :res, :cookie

  def search
    get
    process
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
    doc = Nokogiri::HTML(res.body)

    doc.css("div.market1").each do |elem|
      depart_at = depart_at_selector(elem)
      arrive_at = arrive_at_selector(elem)
      fare = fare_selector(elem)
      flight_number = flight_number_selector(elem)
      origin = origin_selector(elem)
      destination = destination_selector(elem)
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

  def depart_at_selector(elem)
    value = elem
            .css("div.visible-xs")
            .css("table")[1]
            .css("td")[0]
            .text.strip

    value_formatter("depart_at", value)
  end

  def arrive_at_selector(elem)
    value = elem
            .css("div.visible-xs")
            .css("table")[1]
            .css("td")[1]
            .text.strip

    value_formatter("arrive_at", value)
  end

  def fare_selector(elem)
    value = elem
            .css("div.visible-xs > div")
            .text.strip

    value_formatter("fare", value)
  end

  def flight_number_selector(elem)
    value = elem
            .css("div.visible-xs")
            .css("table")[0]
            .text.strip

    value_formatter("flight_number", value)
  end

  def origin_selector(elem)
    elem["onclick"]
      .scan(/~[A-Z]{3}~/)[0]
      .gsub("~", "")
  end

  def destination_selector(elem)
    elem["onclick"]
      .scan(/~[A-Z]{3}~/)[1]
      .gsub("~", "")
  end

  def value_formatter(type, value)
    case type
    when "depart_at", "arrive_at"
      value.gsub!(/\t/, "").match(/^(.*?)(AM|PM)/)[0]
      DateTime.parse("#{date} #{value}").strftime("%I:%M %p")
    when "fare"
      value.gsub(/ MYR/, "")
    when "flight_number"
      value.gsub(/ /, "").gsub(/FLIGHTNO\./, "")
    end
  end
end
