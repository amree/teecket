module Selectors
  module MalaysiaAirlines
    def depart_at_selector(flight)
      depart_arrive_at_formatter(flight["depScheduled"])
    end

    def arrive_at_selector(flight)
      depart_arrive_at_formatter(flight["arrScheduled"])
    end

    def fare_selector(flight)
      fare_formatter(flight["fareDetails"]["totalTripFare"])
    end

    def flight_number_selector(flight, transit)
      if transit
        flight.map do |arr|
          flight_code = arr["operatingAirline"] || arr["marketingAirline"]
          flight_code + arr["flightNumber"]
        end.join(" + ")
      else
        flight["marketingAirline"] + flight["flightNumber"]
      end
    end

    def origin_selector(flight)
      flight["departureAirport"]["code"]
    end

    def destination_selector(flight)
      flight["arrivalAirport"]["code"]
    end

    def depart_arrive_at_formatter(datetime)
      DateTime.parse(datetime).strftime("%I:%M %p")
    end

    def fare_formatter(fare)
      format("%.2f", fare)
    end
  end
end
