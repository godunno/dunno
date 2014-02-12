require 'spec_helper'

describe Api::V1::MessagesController do
  let(:event) { create(:event) }
  let(:student) { create(:student) }
  let(:message) { create(:timeline_user_message) }

  describe "POST #up" do
    before do
      create(:timeline_interaction, timeline: event.timeline, interaction: message)
    end

    it "should increase the up votes" do
      expect do
        post :up, user_id: student.id, id: message.id
      end.to change(message.up_votes, :count).by(1)
    end
  end
end
