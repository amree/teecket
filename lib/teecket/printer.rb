require 'terminal-table'
require 'byebug'

class Printer
  def self.table(rows = [])
    headings = ['Flight', 'Flight #', 'Origin', 'Destination', 'Depart', 'Arrive', 'Fare (RM)']

    rows.each { |row| row[:fare] = row[:fare].rjust(9, ' ') }

    new_rows = rows.map { |row| row.values }

    Terminal::Table.new(headings: headings, rows: new_rows)
  end
end
