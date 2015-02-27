require 'spec_helper'

describe SpreadsheetParser, :vcr do
  let(:parser) { SpreadsheetParser.new(url, header_rows: 1) }
  describe "parsing the spreadsheet" do
    let(:url) { "https://docs.google.com/a/dunnoapp.com/spreadsheets/d/1-UQ3aynn8Khe2vMIsISQNPXUkf9yj-4jen4Ly4eyszs/edit#gid=0" }

    let(:values) { ["Zé da Silva", "ze@gmail.com", "21 99999 9999"] }
    it "should return an array with the content" do
      expect(parser.parse).to eq([values])
    end
  end

  describe "parsing keys from URL" do
    let(:url) { "https://docs.google.com/a/dunnoapp.com/spreadsheets/d/1cU5JqP9vF1kL0rXCP9PF7V5Y157ZrY0YKTpvO_Ku7tM/edit#gid=0" }

    it { expect(parser.key).to eq "1cU5JqP9vF1kL0rXCP9PF7V5Y157ZrY0YKTpvO_Ku7tM" }
  end

  describe "constructor method" do
    it "should call parse on an instance" do
      parser = spy('SpreadsheetParser')
      allow(SpreadsheetParser).to receive(:new).and_return(parser)
      SpreadsheetParser.parse("url")
      expect(parser).to have_received(:parse)
    end
  end
end
