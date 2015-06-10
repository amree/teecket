require 'teecket/flight'
require 'teecket/air_asia'
require 'teecket/malaysia_airlines'
require 'teecket/printer'

require 'byebug'

class Teecket
  def self.search(params)
    airasia = AirAsia.new({ from: params[:from], to: params[:to], date: params[:date] })
    airasia.get

    mas = MalaysiaAirlines.new({ from: params[:from], to: params[:to], date: params[:date] })
    mas.get

    puts Printer.table(airasia.fares + mas.fares)
  end
end
