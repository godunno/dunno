require 'spec_helper'

describe EventStatusNotification do
  let(:event) { create(:event, status: 'draft') }
  let(:profile) { create(:profile) }
  let(:deliverer) { double('DeliverSystemNotifications', deliver: nil) }

  before do
    allow(DeliverSystemNotifications).to receive(:new).and_return(deliverer)
  end

  it "calls DeliverSystemNotifications when canceled" do
    event.update!(status: 'canceled')
    EventStatusNotification.new(event, profile).deliver
    expect(DeliverSystemNotifications).to have_received(:new).with(
      notifiable: event,
      notification_type: :event_canceled,
      course: event.course,
      author: profile
    )
  end

  it "calls DeliverSystemNotifications when published" do
    event.update!(status: 'published')
    EventStatusNotification.new(event, profile).deliver
    expect(DeliverSystemNotifications).to have_received(:new).with(
      notifiable: event,
      notification_type: :event_published,
      course: event.course,
      author: profile
    )
  end

  it "doesn't call DeliverSystemNotifications when there's no change" do
    EventStatusNotification.new(event, profile).deliver
    expect(DeliverSystemNotifications).not_to have_received(:new)
  end

  it "doesn't call DeliverSystemNotifications when it was already published" do
    event.update!(status: 'published')
    event.reload

    event.update!(classroom: 'some classroom')
    EventStatusNotification.new(event, profile).deliver
    expect(DeliverSystemNotifications).not_to have_received(:new)
  end
end
