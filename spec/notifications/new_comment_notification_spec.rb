require 'spec_helper'

describe NewCommentNotification do
  let(:comment) { create(:comment) }
  let(:profile) { create(:profile) }

  it "calls DeliverSystemNotifications with correct parameters" do
    deliverer = double('DeliverSystemNotifications', deliver: nil)
    allow(DeliverSystemNotifications).to receive(:new).and_return(deliverer)
    NewCommentNotification.new(comment, profile).deliver
    expect(DeliverSystemNotifications).to have_received(:new).with(
      notifiable: comment,
      notification_type: :new_comment,
      course: comment.event.course,
      author: profile
    )
  end
end
