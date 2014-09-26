require 'spec_helper'

describe TimelineMessage do
  let(:timeline_message) { build(:timeline_message) }
  describe "associations" do
    it { should belong_to(:student) }
    it { should have_one(:timeline_interaction) }
    it { should have_one(:timeline).through(:timeline_interaction) }
  end
  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:student) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new timeline message" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            timeline_message.save!
          end.to change{timeline_message.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end
