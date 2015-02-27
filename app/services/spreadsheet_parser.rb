require 'google/api_client'
require 'google_drive'

class SpreadsheetParser
  TOKEN = ENV['GOOGLE_DRIVE_TOKEN']

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

  def key
    # url: https://docs.google.com/a/dunnoapp.com/spreadsheets/d/1cU5JqP9vF1kL0rXCP9PF7V5Y157ZrY0YKTpvO_Ku7tM/edit#gid=0
    # key: 1cU5JqP9vF1kL0rXCP9PF7V5Y157ZrY0YKTpvO_Ku7tM
    url.match(%r{/d/([a-zA-Z0-9\-_]+)})[1]
  end

  private

  def client
    @client ||= GoogleDrive.login_with_oauth(TOKEN)
  end
end
