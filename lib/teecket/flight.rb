require "net/http"
require "openssl"
require "json"

class Flight
  attr_accessor :from, :to, :date, :fares

  def initialize(params)
    @from = params[:from]
    @to = params[:to]
    @date = params[:date]
    @verbose = params[:verbose] || false
    @fares = []
  end

  def search
    get
    process
  rescue StandardError => e
    print_error e
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

  def print_error(error)
    if @verbose
      puts "Error: #{error.message}"
      puts error.backtrace
    end
  end
end
