require 'spec_helper'

describe PhoneFormatter do
  context "9 digits" do
    let(:target) { "+55 21 987654321" }

    it "should format variations correctly" do
      ["(21) 98765-4321", "(21) 98765 4321", "(21) 987654321", "21 98765 4321", "21 987654321", "21987654321", "+55 21 98765 4321"].each do |original|
        expect(PhoneFormatter.new(original).format).to eq(target)
      end
    end
  end

  context "8 digits" do
    let(:target) { "+55 21 87654321" }

    it "should format variations correctly" do
      ["(21) 8765-4321", "(21) 8765 4321", "(21) 87654321", "21 8765 4321", "21 87654321", "2187654321", "+55 21 8765 4321"].each do |original|
        expect(PhoneFormatter.new(original).format).to eq(target)
      end
    end
  end

  it "should have a constructor method" do
    formatter = spy('PhoneFormatter')
    number = '21987654321'
    allow(PhoneFormatter).to receive(:new).with(number).and_return(formatter)
    PhoneFormatter.format(number)
    expect(formatter).to have_received(:format)
  end
end
