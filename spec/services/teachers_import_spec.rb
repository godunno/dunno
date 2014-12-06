require 'spec_helper'
require 'webmock/rspec'

describe TeachersImport do
  let(:spreadsheet) { Rails.root.join "spec/fixtures/imports/professores.xlsx" }
  let(:url) { "http://www.example.com/professores.xlsx" }
  before do
    stub_request(:get, url).to_return(body: spreadsheet)
  end

  describe "imports the teacher" do
    before do
      TeachersImport.import(url)
    end

    subject { Teacher.first }

    it { expect(subject.name).to eq("Zé da Silva") }
    it { expect(subject.email).to eq("ze@gmail.com") }
    it { expect(subject.phone_number).to eq("21 99999 9999") }
  end
end
