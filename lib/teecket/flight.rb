require "net/http"
require "openssl"
require "json"

class Flight
  class UnsupportedDateFormat < StandardError
    def message
      "Unsupported date format, please use yyyy-mm-dd"
    end
  end

  attr_accessor :from, :to, :date, :fares

  def initialize(params)
    @from = params[:from]
    @to = params[:to]
    @date = params[:date]
    @verbose = params[:verbose] || false
    @fares = []
  end

  def search
    format_date
    get
    process
  rescue StandardError => e
    print_error e
  end

  private

  def format_date
    @date = Date.parse(@date)
  rescue ArgumentError
    raise Flight::UnsupportedDateFormat
  end

  def add_to_fares(params)
    fares << { flight_number: params[:flight_number],
               origin: params[:origin],
               destination: params[:destination],
               depart_at: params[:depart_at],
               arrive_at: params[:arrive_at],
               seats: params[:seats],
               fare: params[:fare] }
  end

  def print_error(error)
    if @verbose
      puts "Error: #{error.message}"
      puts error.backtrace
    end
  end
end
