module Selectors
  module MalindoAir
    def depart_at_selector(flight)
      depart_arrive_at_formatter(flight["DepartureDate"])
    end

    def arrive_at_selector(flight)
      depart_arrive_at_formatter(flight)
    end

    def fare_selector(flight)
      fare_formatter(flight["FlightAmount"])
    end

    def flight_number_selector(flight)
      flight["SegmentInformation"].map do |trip|
        trip["MACode"] + trip["FlightNo"]
      end.join(" + ")
    end

    def origin_selector(flight)
      flight["DepCity"]
    end

    def destination_selector(elem)
      elem["ArrCity"]
    end

    def depart_arrive_at_formatter(datetime)
      DateTime
        .strptime(datetime.gsub(%r(^\/Date\(|\)\/), ""), "%Q")
        .to_time
        .strftime("%I:%M %p")
    end

    def fare_formatter(fare)
      sprintf("%.2f", fare)
    end
  end
end
