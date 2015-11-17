require 'spec_helper'

describe BuildDigest do
  let(:profile) { create(:profile, last_digest_sent_at: 1.day.ago) }
  let(:course) { create(:course) }
  let(:event) { create(:event, course: course) }
  let(:comment) { create(:comment, event: event) }
  let!(:event_without_notifications) { create(:event, course: course) }
  let!(:old_notification) do
    create :system_notification, :event_published,
           profile: profile,
           created_at: 2.days.ago
  end
  let!(:event_published_notification) do
    create :system_notification, :event_published,
           notifiable: event,
           profile: profile
  end
  let!(:event_canceled_notification) do
    create :system_notification, :event_canceled,
           notifiable: event,
           profile: profile
  end
  let!(:new_comment_notification) do
    create :system_notification, :new_comment,
           notifiable: comment,
           profile: profile
  end
  let!(:blocked_notification) do
    create :system_notification, :blocked,
           notifiable: course,
           profile: profile
  end
  let(:digest) { BuildDigest.new(profile) }

  let(:notifications_digest) do
    event_digest = EventDigest.new(event)
    event_digest.comment_notifications = [new_comment_notification]

    course_digest = CourseDigest.new(course)
    course_digest.blocked_notifications = [blocked_notification]
    course_digest.events = Set[event_digest]

    notifications_digest = NotificationsDigest.new
    notifications_digest.courses = Set[course_digest]
    notifications_digest
  end

  it "sends a digest email with event published notifications" do
    expect(digest.notifications).to eq notifications_digest
  end
end
