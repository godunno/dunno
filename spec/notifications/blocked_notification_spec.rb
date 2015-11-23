require 'spec_helper'

describe BlockedNotification do
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:student) { create(:profile) }
  let(:teacher) { create(:profile) }

  it "creates a SystemNotification for student" do
    expect do
      BlockedNotification.new(course, student).deliver
    end.to change { student.system_notifications.count }.by(1)
    notification = student.system_notifications.last
    expect(notification.notification_type).to eq 'blocked'
    expect(notification.notifiable).to eq course
    expect(notification.author).to eq teacher
  end
end
