require "terminal-table"

class Printer
  def self.table(rows = [])
    headings = [
      "Flight",
      "Flight #",
      "Transit",
      "Origin",
      "Destination",
      "  Depart ",
      "  Arrive ",
      "Fare (RM)"]

    rows.each { |row| row[:fare] = row[:fare].rjust(9, " ") }
    rows.each { |row| row[:depart_at] = row[:depart_at].rjust(8, " ") }
    rows.each { |row| row[:arrive_at] = row[:arrive_at].rjust(8, " ") }

    rows.map!(&:values)

    Terminal::Table.new(headings: headings, rows: rows)
  end
end
