module Selectors
  module Firefly
    def depart_at_selector(flight)
      value = flight
              .css("td")[1]
              .css("div")[0]

      time_formatter(value)
    end

    def arrive_at_selector(flight)
      value = flight
              .css("td")[1]
              .css("div")[1]

      time_formatter(value)
    end

    def fare_selector(flight)
      value = flight
              .css("td")[2]
              .css("div")[1]
              .text
    end

    def flight_number_selector(flight)
      value = flight
              .css("td")[0]
              .text
    end

    def origin_destination_selector(html)
      text = html.css('form > div')[1].text
      text.scan(/[A-Z]{3}/)
    end


    def time_formatter(element)
      DateTime.strptime(element.text, "%l:%M%p")
              .strftime("%I:%M %p")
    end
  end
end
