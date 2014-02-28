require 'spec_helper'

describe Thermometer do

  let(:thermometer) { build(:thermometer) }

  describe "associations" do
    it { should belong_to(:event) }
    it { should have_many(:ratings) }
  end

  describe "validations" do
    [:content, :event].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new event" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            thermometer.save!
          end.to change{thermometer.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end

