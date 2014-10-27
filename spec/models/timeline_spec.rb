require 'spec_helper'

describe Timeline do

  describe "association" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to have_many(:timeline_interactions) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:start_at) }
  end

  describe "#interactions" do
    let(:timeline) { create :timeline }
    let(:message) { create :timeline_message }

    before do
      create(:timeline_interaction, timeline: timeline, interaction: message)
    end

    it { expect(timeline.interactions).to include message }
  end
end
