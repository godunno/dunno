class SpreadsheetParser
  attr_reader :url, :options

  def self.parse(*args)
    new(*args).parse
  end

  def initialize(url, options = { header_rows: 0 })
    @url = url
    @options = options
  end

  def parse
    file = open(url)
    spreadsheet = Roo::Spreadsheet.open(file.path, extension: :xlsx)
    ((options[:header_rows] + 1)..spreadsheet.last_row).map { |i| spreadsheet.row(i) }
  end
end
