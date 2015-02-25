require 'google/api_client'
require 'google_drive'

class SpreadsheetParser
  TOKEN = "ya29.JAERb1uc60CjB88EmX4vy8i5nsEf-DCO2ClbwmjsUBBydNxn-uZ7KeWcr1DCpZREed8qO5iNGSKzrg"

  attr_reader :url, :options

  def self.parse(*args)
    new(*args).parse
  end

  def initialize(url, options = { header_rows: 0 })
    @url = url
    @options = options
  end

  def parse
    spreadsheet = client.spreadsheet_by_key(key)
    spreadsheet.worksheets.first.rows.drop(options[:header_rows])
  end

  private

  def client
    @client ||= GoogleDrive.login_with_oauth(TOKEN)
  end

  def key
    # grab the /d/<key>/ from google spreadsheet url
    url.match(%r{/d/([a-zA-Z0-9\-]+)})[1]
  end
end
