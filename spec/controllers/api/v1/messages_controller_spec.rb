require 'spec_helper'

describe Api::V1::MessagesController do
  let(:event) { create(:event) }
  let(:student) { create(:student) }
  let(:message) { create(:timeline_user_message) }

  describe "POST #up", vcr: { match_requests_on: [:method, :host, :path]} do
    before do
      create(:timeline_interaction, timeline: event.timeline, interaction: message)
    end

    it "should increase the up votes" do
      expect do
        post :up, user_id: student.id, id: message.id
      end.to change(message.up_votes, :count).by(1)
    end

    it "triggers pusher event to notify pusher" do
      EventPusher.any_instance.should_receive(:up_down_vote_message).with(1, 0).once
      post :up, user_id: student.id, id: message.id
    end
  end

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
