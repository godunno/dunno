require 'spec_helper'

describe BuildDigest do
  let(:profile) { create(:profile, last_digest_sent_at: 1.day.ago) }
  let(:course) { create(:course) }
  let(:event) { create(:event, course: course) }
  let(:another_event) { create(:event, course: course) }
  let(:comment) { create(:comment, event: event) }
  let(:topic) { create(:topic, event: another_event, order: 2) }
  let!(:personal_topic) { create(:topic, :personal, event: event) }
  let!(:existent_topic_for_event) { create(:topic, event: event, order: 1) }
  let!(:existent_topic_for_another_event) { create(:topic, event: another_event, order: 1) }
  let!(:event_without_notifications) { create(:event, course: course) }
  let!(:event_published_notification) do
    create :system_notification, :event_published,
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
  let!(:new_member_notification) do
    create :system_notification, :new_member,
           notifiable: course,
           profile: profile
  end
  let!(:new_topic_notification) do
    create :system_notification, :new_topic,
           notifiable: topic,
           profile: profile
  end
  let(:digest) do
    BuildDigest.new(profile, [
      event_published_notification,
      new_comment_notification,
      blocked_notification,
      new_member_notification,
      new_topic_notification
    ])
  end

  let(:course_digest) { digest.notifications.courses.first }
  let(:event_digest) { course_digest.events.first }
  let(:another_event_digest) { course_digest.events.second }

  it do
    expect(digest.notifications.courses.length).to be 1
  end

  it do
    expect(course_digest.course).to eq course
  end

  it do
    expect(course_digest.blocked_notifications).to eq [blocked_notification]
  end

  it do
    expect(course_digest.member_notifications).to eq [new_member_notification]
  end

  it do
    expect(course_digest.events.count).to be 2
  end

  it do
    expect(event_digest.event).to eq event
  end

  it do
    expect(another_event_digest.event).to eq another_event
  end

  it do
    expect(event_digest.status_notifications).to eq [event_published_notification]
  end

  it do
    expect(another_event_digest.status_notifications).to eq []
  end

  it do
    expect(event_digest.comment_notifications).to eq [new_comment_notification]
  end

  it do
    expect(another_event_digest.comment_notifications).to eq []
  end

  it do
    expect(event_digest.topic_notifications).to eq []
  end

  it do
    expect(another_event_digest.topic_notifications).to eq [new_topic_notification]
  end

  it do
    expect(event_digest.topics).to eq [existent_topic_for_event]
  end

  it do
    expect(another_event_digest.topics).to eq [topic]
  end

  context "published then canceled in the same day" do
    let!(:event_canceled_notification) do
      create :system_notification, :event_canceled,
             notifiable: event,
             profile: profile
    end

    let(:digest) do
      BuildDigest.new(profile, [
        event_published_notification,
        event_canceled_notification,
      ])
    end

    before do
      event_published_notification.update!(created_at: 2.hours.ago)
    end

    it do
      expect(event_digest.status_notifications).to eq [event_canceled_notification]
    end
  end

  context "published then added new topic in the same day" do
    before do
      topic.update!(event: event)
    end

    it do
      expect(event_digest.topic_notifications).to eq []
    end

    it do
      expect(event_digest.topics).to eq [topic, existent_topic_for_event]
    end
  end

  context "student registered in the course twice in the same day" do
    let!(:another_new_member_notification) do
      create :system_notification, :new_member,
             author: new_member_notification.author,
             notifiable: course,
             profile: profile
    end
    let(:digest) do
      BuildDigest.new(profile, [
        new_member_notification,
        another_new_member_notification,
      ])
    end

    it do
      expect(course_digest.member_notifications).to eq [new_member_notification]
    end
  end
end
