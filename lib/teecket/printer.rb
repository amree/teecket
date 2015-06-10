require 'terminal-table'

class Printer
  def self.table(rows = [])
    Terminal::Table.new(:headings => ['Flight', 'Flight #', 'Departure', 'Arrival', 'Fare (RM)'], :rows => rows)
  end
end
