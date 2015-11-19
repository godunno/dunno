require 'spec_helper'

describe DeliverSystemNotifications do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:blocked_student) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student, blocked_student]) }
  let(:event) { create(:event, course: course) }

  before do
    blocked_student.block_in! course
  end

  it "delivers event_canceled notification for each course member" do
    DeliverSystemNotifications.new(
      notifiable: event,
      notification_type: :event_canceled,
      course: course,
      author: teacher
    ).deliver

    student_notification = student.system_notifications.last
    expect(student_notification.notifiable).to eq event
    expect(student_notification.notification_type).to eq 'event_canceled'

    teacher_notification = teacher.system_notifications.last
    expect(teacher_notification.notifiable).to eq event
    expect(teacher_notification.notification_type).to eq 'event_canceled'

    expect(blocked_student.system_notifications).to be_empty
  end
end
