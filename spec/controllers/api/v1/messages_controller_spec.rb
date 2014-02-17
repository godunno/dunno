require 'spec_helper'

describe Api::V1::MessagesController do
  let(:event) { create(:event) }
  let(:student) { create(:student) }
  let(:message) { create(:timeline_user_message) }

  describe "POST #down", vcr: { match_requests_on: [:method, :host, :path]} do
    before do
      create(:timeline_interaction, timeline: event.timeline, interaction: message)
    end

    it "should decrease the up votes" do
      expect do
        post :down, user_id: student.id, id: message.id
      end.to change(message.down_votes, :count).by(1)
    end

    it "triggers pusher event to notify pusher" do
      EventPusher.any_instance.should_receive(:up_down_vote_message).with(0, 1).once
      post :down, user_id: student.id, id: message.id
    end
  end
end
