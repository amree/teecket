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
        html.css("td:first td.avail-table-detail")[0].text.strip[0..4])
    end

    def arrive_at_selector(html)
      datetime_formatter(
        html.css("td:first td.avail-table-detail")[1].text.strip[0..4])
    end

    def fare_selector(html)
      html.css("> td.LF").text.strip.split(" ").first
    end

    def flight_number_selector(html)
      html.css("td:first div.carrier-hover-bold").first.text.delete(" ")
    end

# TEST TEST
    def seats_selector(html)
      html.css("div.avail-table-seats-remaining").text.strip.split(" ").first
    end

    def datetime_formatter(datetime)
      DateTime.parse(datetime).strftime("%I:%M %p")
    end
  end
end
