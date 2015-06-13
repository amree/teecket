module Selectors
  module Firefly
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
end
