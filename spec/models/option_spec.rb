require 'spec_helper'

describe Option do

  let(:option) { build :option }

  describe "associations" do
    it { should belong_to(:poll) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new option" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            option.save!
          end.to change{option.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end
