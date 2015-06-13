require "net/http"
require "openssl"
require "json"

class Flight
  attr_reader :from, :to, :date, :fares

  def initialize(params)
    @from = params[:from]
    @to = params[:to]
    @date = params[:date]

    @fares = []
  end

  def search
    raise NotImplementedError
  end

  private

  def add_to_fares(params)
    fares << { flight_name: params[:flight_name],
               flight_number: params[:flight_number],
               transit: params[:transit],
               origin: params[:origin],
               destination: params[:destination],
               depart_at: params[:depart_at],
               arrive_at: params[:arrive_at],
               fare: params[:fare] }
  end
end
