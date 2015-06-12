require "nokogiri"

class Firefly < Flight
  include PageRequester

  def get
    uri = URI("https://m.fireflyz.com.my/")

    req = Net::HTTP::Get.new(uri.path)

    res = request(uri, req)

    cookie = res["Set-Cookie"]

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

    res = request(uri, req)

    if res["location"]
      uri = URI(res["location"])

      req = Net::HTTP::Get.new(uri.path, "Cookie" => cookie)

      res = request(uri, req)

      doc = Nokogiri::HTML(res.body)

      doc.css("div.market1").each_with_index do |_elem, i|
        depart_at = doc.css("div.market1")[i]
                    .css("div.visible-xs")
                    .css("table")[1]
                    .css("td")[0]
                    .text.strip

        arrive_at = doc
                    .css("div.market1")[i]
                    .css("div.visible-xs")
                    .css("table")[1]
                    .css("td")[1]
                    .text.strip

        fare = doc
               .css("div.market1")[i]
               .css("div.visible-xs > div")
               .text.strip

        flight_number = doc
                        .css("div.market1")[i]
                        .css("div.visible-xs")
                        .css("table")[0]
                        .text.strip

        origin = doc
                 .css("div.market1")[i]["onclick"]
                 .scan(/~[A-Z]{3}~/)[0]
                 .gsub("~", "")

        destination = doc
                      .css("div.market1")[i]["onclick"]
                      .scan(/~[A-Z]{3}~/)[1]
                      .gsub("~", "")

        transit = "NO"

        depart_at = DateTime
                    .parse("#{date} #{depart_at.gsub(/\t/, '')
                    .match(/^(.*?)(AM|PM)/)}")
                    .strftime("%I:%M %p")

        arrive_at = DateTime.parse("#{date} #{arrive_at.gsub(/\t/, '')
                    .match(/^(.*?)(AM|PM)/)}")
                    .strftime("%I:%M %p")

        fare = fare.gsub(/ MYR/, "")
        flight_number = flight_number.gsub(/ /, "").gsub(/FLIGHTNO\./, "")

        fares << { flight_name: "Firefly",
                   flight_number: flight_number,
                   transit: transit,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare }
      end
    end
  end
end
