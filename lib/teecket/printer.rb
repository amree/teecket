require 'terminal-table'

class Printer
  def self.table(rows = [])
    headings = ['Flight', 'Flight #', 'Origin', 'Destination', 'Depart', 'Arrive', 'Fare (RM)']

    new_rows = rows.map { |row| row.values }

    Terminal::Table.new(headings: headings, rows: new_rows)
  end
end
