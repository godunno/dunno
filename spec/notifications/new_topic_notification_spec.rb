require 'spec_helper'

describe NewTopicNotification do
  let(:topic) { create(:topic, event: event) }
  let(:profile) { create(:profile) }
  let(:deliverer) { double('DeliverSystemNotifications', deliver: nil) }

  before do
    allow(DeliverSystemNotifications).to receive(:new).and_return(deliverer)
  end

  context "event is already published" do
    let(:event) { create(:event, :published) }
    it "calls DeliverSystemNotifications" do
      NewTopicNotification.new(topic, profile).deliver
      expect(DeliverSystemNotifications).to have_received(:new).with(
        notifiable: topic,
        notification_type: 'new_topic',
        course: event.course,
        author: profile
      )
    end
  end

  context "event is draft" do
    let(:event) { create(:event, :draft) }
    it "doesn't call DeliverSystemNotifications" do
      NewTopicNotification.new(topic, profile).deliver
      expect(DeliverSystemNotifications).not_to have_received(:new)
    end
  end

  context "event is canceled" do
    let(:event) { create(:event, :canceled) }
    it "doesn't call DeliverSystemNotifications" do
      NewTopicNotification.new(topic, profile).deliver
      expect(DeliverSystemNotifications).not_to have_received(:new)
    end
  end
end
