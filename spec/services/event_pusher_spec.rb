require 'spec_helper'

describe EventPusher do
  let(:event) { create :event }

  before do
    Pusher.stub(:trigger)
    @event_pusher = EventPusher.new(event)
  end

  describe "#student_message" do

    let(:message) { create :timeline_user_message }

    before do
      @event_pusher.student_message(message.content)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        event.student_message_event,
        { content: message.content }
      )
    end

    it "should call this method after creating a TimelineUserMessage" do
      message = "Message"
      EventPusher.any_instance.should_receive(:student_message).with(message)
      create :timeline_user_message, content: message, timeline_interaction: (build :timeline_interaction)
    end
  end

  describe "#up_down_vote_message" do

    let(:up) { 1 }
    let(:down) { 2 }

    before do
      @event_pusher.up_down_vote_message(up, down)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        event.up_down_vote_message_event,
        { up: up, down: down }
      )
    end
  end

  describe "#receive_poll" do

    let(:poll) { {} }

    before do
      pending "Preencher com os dados que o Pusher deve receber"
      @event_pusher.receive_poll(poll)
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        event.channel,
        event.receive_poll_event,
        {}
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
        event.receive_rating_event,
        {}
      )
    end
  end
end
