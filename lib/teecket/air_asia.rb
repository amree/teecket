class AirAsia < Flight
  include PageRequester
  include Selectors::AirAsia

  attr_accessor :res

  private

  # dd-mm-yyyy
  def formatted_date
    "#{date.mday}-#{date.mon}-#{date.year}"
  end

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
      transit = "NO"

      add_to_fares(flight_name: "AirAsia",
                   flight_number: flight_number,
                   transit: transit,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare)
    end
  end

  def parameters
    [
      "o1=#{from}",
      "d1=#{to}",
      "dd1=#{date}",
      "ADT=1",
      "CHD=0",
      "inl=0"
    ].join("&")
  end
end
