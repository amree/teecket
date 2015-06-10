require 'date'

require 'teecket/flight'
require 'teecket/air_asia'
require 'teecket/malaysia_airlines'
require 'teecket/malindo_air'
require 'teecket/firefly'

class Teecket
  def self.search(params)
    airasia = AirAsia.new({ from: params[:from], to: params[:to], date: params[:date] })
    airasia.get

    firefly = Firefly.new({ from: params[:from], to: params[:to], date: params[:date] })
    firefly.get

    mas = MalaysiaAirlines.new({ from: params[:from], to: params[:to], date: params[:date] })
    mas.get

    malindo = MalindoAir.new({ from: params[:from], to: params[:to], date: params[:date] })
    malindo.get

    output = airasia.fares + mas.fares + malindo.fares + firefly.fares
  end
end
