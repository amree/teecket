require "date"
require "thwait"

require "teecket/page_requester"
require "teecket/selectors/air_asia"
require "teecket/selectors/malaysia_airlines"
require "teecket/selectors/malindo_air"
require "teecket/selectors/firefly"
require "teecket/flight"
require "teecket/air_asia"
require "teecket/malaysia_airlines"
require "teecket/malindo_air"
require "teecket/firefly"

class Teecket
  def self.search(params)
    flights = %w(AirAsia Firefly MalaysiaAirlines MalindoAir)

    results = []
    flights.each do |flight|
      klass = Object.const_get(flight)

      scrapper = klass.new(from: params[:from],
                           to: params[:to],
                           date: params[:date])

      scrapper.search

      results += scrapper.fares
    end

    results
  end
end
