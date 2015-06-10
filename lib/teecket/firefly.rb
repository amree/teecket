require 'nokogiri'

class Firefly < Flight
  def get

    uri = URI('https://m.fireflyz.com.my/')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.path)

    res = http.request(req)

    cookie = res['Set-Cookie']

    uri = URI('https://m.fireflyz.com.my/Search')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.path, initheader = { 'Cookie' => cookie})

    cookie = res['Set-Cookie']

    uri = URI('https://m.fireflyz.com.my/Search')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path, initheader = { 'Cookie' => cookie})
    req.body = "type=2&departure_station=#{from}&arrival_station=#{to}&departure_date=#{date}&return_date=30%2F06%2F2015&adult=1&infant=0"

    res = http.request(req)

    if res['location']
      uri = URI(res['location'])

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Get.new(uri.path, initheader = { 'Cookie' => cookie})

      res = http.request(req)

      doc = Nokogiri::HTML(res.body)

      doc.css('div.market1').each_with_index do |elem, i|
        depart_at     = doc.css('div.market1')[i].css('div.visible-xs').css('table')[1].css('td')[0].text.strip
        arrive_at     = doc.css('div.market1')[i].css('div.visible-xs').css('table')[1].css('td')[1].text.strip
        fare          = doc.css('div.market1')[i].css('div.visible-xs > div').text.strip
        flight_number = doc.css('div.market1')[i].css('div.visible-xs').css('table')[0].text.strip
        origin        = doc.css('div.market1')[i]['onclick'].scan(/~[A-Z]{3}~/)[0].gsub('~', '')
        destination   = doc.css('div.market1')[i]['onclick'].scan(/~[A-Z]{3}~/)[1].gsub('~', '')

        depart_at     = DateTime.parse("#{date} #{depart_at.gsub(/\t/, '').match(/^(.*?)(AM|PM)/).to_s}").strftime('%I:%M %p')
        arrive_at     = DateTime.parse("#{date} #{arrive_at.gsub(/\t/, '').match(/^(.*?)(AM|PM)/).to_s}").strftime('%I:%M %p')
        fare          = fare.gsub(/ MYR/, '')
        flight_number = flight_number.gsub(/ /, '').gsub(/FLIGHTNO\./, '')

        fares << { flight_name: 'Firefly',
                   flight_number: flight_number,
                   origin: origin,
                   destination: destination,
                   depart_at: depart_at,
                   arrive_at: arrive_at,
                   fare: fare }
      end
    end
  end
end
