require 'spec_helper'

describe TeachersImport do
  let(:name) { "Zé da Silva" }
  let(:email) { "ze@gmail.com" }
  let(:phone_number) { "21 99999 9999" }
  let(:url) { "http://www.example.com/professores.xlsx" }
  before do
    allow(SpreadsheetParser).to receive(:parse).with(url, header_rows: 1).and_return([[name, email, phone_number]])
  end

  describe "imports the teacher" do
    before do
      TeachersImport.new(url).import!
    end

    subject { Profile.first }

    it { expect(subject.name).to eq(name) }
    it { expect(subject.email).to eq(email) }
    it { expect(subject.phone_number).to eq(phone_number) }
  end

  describe "constructor method" do
    it "should call import! on an instance" do
      import = spy('TeachersImport')
      allow(TeachersImport).to receive(:new).and_return(import)
      TeachersImport.import!(url)
      expect(import).to have_received(:import!)
    end
  end
end
