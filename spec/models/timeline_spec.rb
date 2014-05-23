require 'spec_helper'

describe Timeline do

  describe "association" do
    it { should belong_to(:event) }
    it { should have_many(:timeline_interactions) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_at) }
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
