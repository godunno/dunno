require 'spec_helper'
require 'webmock/rspec'

describe SpreadsheetParser do
  describe "parsing the spreadsheet" do
    let(:spreadsheet) { File.open("spec/fixtures/imports/professores.xlsx") }
    let(:url) { "http://www.example.com/professores.xlsx" }
    before do
      stub_request(:get, url).to_return(body: spreadsheet)
    end

    let(:values) { ["Zé da Silva", "ze@gmail.com", "21 99999 9999"] }
    it "should return an array with the content" do
      expect(SpreadsheetParser.new(url, header_rows: 1).parse).to eq([values])
    end
  end

  describe "constructor method" do
    it "should call parse on an instance" do
      parser = spy('SpreadsheetParser')
      allow(SpreadsheetParser).to receive(:new).and_return(parser)
      SpreadsheetParser.parse("url")
      expect(parser).to have_received(:parse)
    end
  end

  it "should work on lightweight files" do
    spreadsheet = File.open("spec/fixtures/imports/lightweight-file.xlsx")
    url = "http://www.example.com/lightweight-file.xlsx"
    stub_request(:get, url).to_return(body: spreadsheet)
    expect { SpreadsheetParser.new(url, header_rows: 1).parse }.not_to raise_error
  end
end
