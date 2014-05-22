require 'spec_helper'

describe EventPusher do

  let(:event) { create :event }
  let(:student_pusher_events) { EventPusherEvents.new(create(:student)) }
  let(:teacher_pusher_events) { EventPusherEvents.new(create(:teacher)) }

  before do
    Pusher.stub(:trigger)
    @event_pusher = EventPusher.new(event)
  end

  describe "#student_message" do

    let(:message) { create :timeline_user_message }
    let(:timeline) { create :timeline }
    let(:student) { create :student }

    before do
      @event_pusher.student_message(message)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        student_pusher_events.student_message_event,
        @event_pusher.pusher_message_json(message)
      )
    end

    describe "#pusher_message_json" do
      let(:pusher_expected_message_json) { @event_pusher.pusher_message_json(message) }

      it "should return full attributes from student associated" do
        message_hash = JSON.parse(pusher_expected_message_json)
        expect(message_hash["student"]).to_not be_nil
        expect(message_hash["student"]["id"]).to_not be_nil
        expect(message_hash["student"]["email"]).to_not be_nil
        expect(message_hash["up_votes"]).to_not be_nil
        expect(message_hash["down_votes"]).to_not be_nil
      end
    end

  end

  describe "#up_down_vote_message" do

    let(:message) { create :timeline_user_message }

    before do
      @event_pusher.up_down_vote_message(message)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        student_pusher_events.up_down_vote_message_event,
        @event_pusher.pusher_message_json(message)
      )
    end
  end

  describe "#receive_rating" do

    let(:rating) { {} }

    before do
      pending "Preencher com os dados que o Pusher deve receber"
      @event_pusher.receive_rating(rating)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        student_pusher_events.receive_rating_event,
        {}
      )
    end
  end

  describe "#close" do

    before do
      @event_pusher.close
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        teacher_pusher_events.close_event,
        @event_pusher.pusher_close_event_json
      )
    end
  end

  describe "#release_poll" do

    let(:poll) { create :poll, timeline: event.timeline }

    before do
      @event_pusher.release_poll(poll)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        teacher_pusher_events.release_poll_event,
        @event_pusher.pusher_poll_json(poll)
      )
    end
  end

  describe "#release_media" do

    let(:media) { create :media, timeline: event.timeline }

    before do
      @event_pusher.release_media(media)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        teacher_pusher_events.release_media_event,
        @event_pusher.pusher_media_json(media)
      )
    end
  end
end
