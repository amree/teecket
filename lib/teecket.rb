# encoding: utf-8
require "date"

require "teecket/flight"
require "teecket/air_asia"
require "teecket/malaysia_airlines"
require "teecket/malindo_air"
require "teecket/firefly"

class Teecket
  def self.search(params)
    flights = [
      "AirAsia",
      "Firefly",
      "MalaysiaAirlines",
      "MalindoAir"
    ]

    results = []
    flights.each do |flight|
      klass = Object.const_get(flight)

      scrapper = klass.new(from: params[:from],
                           to: params[:to],
                           date: params[:date])

      scrapper.get

      results = results + scrapper.fares
    end

    results
  end
end
