module Selectors
  module AirAsia
    def flights(html)
      html.css("table.avail-table tr[class^=fare]")
    end

    def origin_destination_selector(html)
      html.css("div.price-display-header-stations").text.scan(/[A-Z]{3}/)
    end

    def depart_at_selector(html)
      datetime_formatter(
        html.css("td:first td")[1].text.gsub(" ", "").strip[0..4])
    end

    def arrive_at_selector(html)
      datetime_formatter(
        html.css("td:first td")[3].text.gsub(" ", "").strip[0..4])
    end

    def fare_selector(html)
      html.css("td:last div.avail-fare-price").text.strip.split(" ").first
    end

    def flight_number_selector(html)
      html.css("td:first div.carrier-hover-bold").first.text.gsub(" ", "")
    end

    def datetime_formatter(datetime)
      DateTime.parse(datetime).strftime("%I:%M %p")
    end
  end
end
