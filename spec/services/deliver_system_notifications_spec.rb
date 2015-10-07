require 'spec_helper'

describe DeliverSystemNotifications do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:event) { create(:event, course: course) }

  def assert_notification(notifiable, notification_type)
    student_notification = student.system_notifications.last
    expect(student_notification.notifiable).to eq notifiable
    expect(student_notification.notification_type).to eq notification_type

    teacher_notification = teacher.system_notifications.last
    expect(teacher_notification.notifiable).to eq notifiable
    expect(teacher_notification.notification_type).to eq notification_type
  end

  it "delivers event_canceled notification for each course member" do
    DeliverSystemNotifications.new(
      notifiable: event,
      notification_type: :event_canceled,
      course: course,
      author: teacher
    ).deliver
    assert_notification(event, 'event_canceled')
  end

  describe ".detect" do
    it "initializes properly a DeliverSystemNotifications for event_canceled" do
      event.update!(status: :canceled)
      DeliverSystemNotifications.detect(event, teacher).deliver
      assert_notification(event, 'event_canceled')
    end

    it "initializes properly a DeliverSystemNotifications for event_published" do
      event.update!(status: :published)
      DeliverSystemNotifications.detect(event, teacher).deliver
      assert_notification(event, 'event_published')
    end

    it "initializes properly a DeliverSystemNotifications for new_comment" do
      comment = create(:comment, event: event)
      DeliverSystemNotifications.detect(comment, teacher).deliver
      assert_notification(comment, 'new_comment')
    end

    it "doesn't send notifications when there's nothing to be sent" do
      event.update!(classroom: 'some other classroom')
      expect {
        DeliverSystemNotifications.detect(event, teacher).deliver
      }.not_to change { SystemNotification.count }

      comment = create(:comment).reload
      comment.update!(body: 'some text')
      expect {
        DeliverSystemNotifications.detect(comment, teacher).deliver
      }.not_to change { SystemNotification.count }
    end

    it "raises an error if passing some class where there's no notification" do
      expect {
        DeliverSystemNotifications.detect(User.new, teacher).deliver
      }.to raise_error(DeliverSystemNotifications::NoSystemNotificationForClass)
    end
  end
end
