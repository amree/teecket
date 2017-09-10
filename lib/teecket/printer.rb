require "terminal-table"

class Printer
  def self.table(rows = [])
    headings = [
      "Flight #",
      "Origin",
      "Destination",
      "Depart",
      "Arrive",
      "Seats Left",
      "Fare (PHP)"]

    rows.each { |row| row[:fare] = row[:fare].rjust(9, " ") }

    rows.map!(&:values)

    Terminal::Table.new(headings: headings, rows: rows)
  end
end