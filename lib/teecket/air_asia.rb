class AirAsia < Flight
  include PageRequester
  include Selectors::AirAsia

  attr_accessor :res

  private

  def get
    url = "https://booking.airasia.com/Flight/Select?#{parameters}"
    uri = URI(url)

    req = Net::HTTP::Get.new(uri)

    self.res = request(uri, req)
  end

  def process
    html = Nokogiri::HTML(res.body)

    origin, destination = origin_destination_selector(html)

    flights(html).each_with_index do |flight, index|
      if index % 2 > 0
        next
      end

      depart_at = depart_at_selector(flight)
      arrive_at = arrive_at_selector(flight)
      fare = fare_selector(flight)
      flight_number = flight_number_selector(flight)

      seats = seats_selector(flight)
      
      if (seats.to_i >= 3 || seats.nil?)

          if seats.nil?
            seats = "unlimited"
          end

          add_to_fares(flight_number: flight_number,
                  origin: origin,
                  destination: destination,
                  depart_at: depart_at,
                  arrive_at: arrive_at,
                  seats: seats,
                  fare: fare)
      end

    end
  end

  def parameters
    [
      "o1=#{from}",
      "d1=#{to}",
      "dd1=#{formatted_date}",
      "ADT=1",
      "CHD=0",
      "inl=0"
    ].join("&")
  end

  def formatted_date
    "#{date.year}-#{date.strftime('%m')}-#{date.strftime('%d')}"
  end
end
