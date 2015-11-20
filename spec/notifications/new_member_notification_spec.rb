require 'spec_helper'

describe NewMemberNotification do
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:student) { create(:profile) }
  let(:teacher) { create(:profile) }

  it "creates a SystemNotification for student" do
    expect do
      NewMemberNotification.new(course, student).deliver
    end.to change { teacher.system_notifications.count }.by(1)
    notification = teacher.system_notifications.last
    expect(notification.notification_type).to eq 'new_member'
    expect(notification.notifiable).to eq course
    expect(notification.author).to eq student
  end
end
