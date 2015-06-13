module Selectors
  module AirAsia
    def depart_at_selector(flight)
      depart_arrivate_at_formatter(flight["segments"][0]["departure-datetime"])
    end

    def arrive_at_selector(flight)
      depart_arrivate_at_formatter(flight["segments"][0]["arrival-datetime"])
    end

    def fare_selector(flight)
      fare_formatter(flight["total"]["adult"])
    end

    def flight_number_selector(flight)
      flight_number_formatter(flight["segments"][0]["flight-number"])
    end

    def origin_selector(flight)
      flight["segments"][0]["origincode"]
    end

    def destination_selector(flight)
      flight["segments"][0]["destinationcode"]
    end

    def depart_arrivate_at_formatter(datetime)
      DateTime.parse(datetime).strftime("%I:%M %p")
    end

    def fare_formatter(fare)
      sprintf("%.2f", fare)
    end

    def flight_number_formatter(flight_number)
      flight_number.gsub(/ /, "")
    end
  end
end
