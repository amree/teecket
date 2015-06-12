# encoding: utf-8
require "terminal-table"

class Printer
  def self.table(rows = [])
    headings = ["Flight", "Flight #", "Transit", "Origin", "Destination", "Depart", "Arrive", "Fare (RM)"]

    rows.each { |row| row[:fare] = row[:fare].rjust(9, " ") }

    rows.map!(&:values)

    Terminal::Table.new(headings: headings, rows: rows)
  end
end
