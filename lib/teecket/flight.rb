require 'net/http'
require 'openssl'
require 'json'

class Flight
  attr_reader :from, :to, :date, :fares

  def initialize(params)
    @from  = params[:from]
    @to    = params[:to]
    @date  = params[:date]

    @fares = []
  end
end
