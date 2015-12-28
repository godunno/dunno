require 'spec_helper'

describe PromotedToModeratorNotification do
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:student) { create(:profile) }
  let(:teacher) { create(:profile) }

  it "creates a SystemNotification for student" do
    expect do
      PromotedToModeratorNotification.new(course, student).deliver
    end.to change { student.system_notifications.count }.by(1)
    notification = student.system_notifications.last
    expect(notification.notification_type).to eq 'promoted_to_moderator'
    expect(notification.notifiable).to eq course
    expect(notification.author).to eq teacher
  end
end

