require 'spec_helper'

describe TimelineMessage do
  let(:timeline_message) { build(:timeline_message) }
  describe "associations" do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to have_one(:timeline_interaction) }
    it { is_expected.to have_one(:timeline).through(:timeline_interaction) }
  end
  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:student) }
  end

  describe "callbacks" do

    describe "after create" do
      context "new timeline message" do
        it "saves a new uuid" do
          expect(timeline_message.uuid).to be_nil
          timeline_message.save!
          expect(timeline_message.uuid).not_to be_nil
        end
      end
    end
  end
end
