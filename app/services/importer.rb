class Importer
  class << self
    attr_reader :beginning_of_data

    def import(url)
      file = open(url)
      new(file).import
    end

    def header_rows(rows)
      @beginning_of_data = rows + 1
    end
  end

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def import
    spreadsheet = Roo::Spreadsheet.open(file.path, extension: :xlsx)

    ActiveRecord::Base.transaction do
      (self.class.beginning_of_data..spreadsheet.last_row).each do |i|
        populate!(spreadsheet.row(i))
      end
    end
  end
end
