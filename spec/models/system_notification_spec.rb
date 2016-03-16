require 'spec_helper'

RSpec.describe SystemNotification, type: :model do
  let(:system_notification) { build(:system_notification, :event_canceled) }

  describe "association" do
    it { is_expected.to belong_to(:author).class_name('Profile') }
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:notifiable) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:profile) }
    it { is_expected.to validate_presence_of(:notifiable) }
    it { is_expected.to validate_presence_of(:notification_type) }

    describe "notifiable validations" do
      let(:event) { build(:event) }
      let(:course) { build(:course) }
      let(:comment) { build(:comment) }
      let(:topic) { build(:topic) }

      def test_notifiable_matches_notification_type(notification_type, notifiable, not_notifiable)
        notification = build :system_notification,
                             notification_type: notification_type,
                             notifiable: notifiable
        expect(notification).to be_valid

        notification.notifiable = not_notifiable
        expect(notification).not_to be_valid
        expect(notification.errors).to have_key :notifiable
      end

      it "validates that an event_canceled notification has an event as notifiable" do
        test_notifiable_matches_notification_type(:event_canceled, event, course)
      end

      it "validates that an event_published notification has an event as notifiable" do
        test_notifiable_matches_notification_type(:event_published, event, course)
      end

      it "validates that a new_comment notification has a comment as notifiable" do
        test_notifiable_matches_notification_type(:new_comment, comment, course)
      end

      it "validates that a blocked notification has a course as notifiable" do
        test_notifiable_matches_notification_type(:blocked, course, event)
      end

      it "validates that a promoted_to_moderator notification has a course as notifiable" do
        test_notifiable_matches_notification_type(:promoted_to_moderator, course, event)
      end

      it "validates that a new_member notification has a course as notifiable" do
        test_notifiable_matches_notification_type(:new_member, course, event)
      end

      it "validates that a new_topic notification has a course as notifiable" do
        test_notifiable_matches_notification_type(:new_topic, topic, event)
      end
    end
  end

  describe ".more_recent_than" do
    let!(:notification) do
      create(:system_notification, :event_canceled)
    end

    let!(:older_notification) do
      create :system_notification, :event_canceled,
             created_at: 1.hour.ago
    end

    it "returns only recent notifications" do
      expect(SystemNotification.more_recent_than(1.minute.ago))
        .to eq [notification]
    end

    it "returns all if no time is sent" do
      expect(SystemNotification.more_recent_than(nil))
        .to eq [notification, older_notification]
    end
  end

  describe "#notification_type" do
    it do
      is_expected.to define_enum_for(:notification_type)
        .with %w(
                  event_canceled
                  event_published
                  new_comment
                  blocked
                  promoted_to_moderator
                  new_member
                  new_topic
                )
    end
  end

  describe ".without_author" do
    it "should filter out the author when listing notifications" do
      profile = create(:profile)
      notification_from_himself = create :system_notification, :event_canceled,
                                         author: profile, profile: profile
      notification_from_someone_else = create :system_notification, :new_comment,
                                              profile: profile

      expect(profile.system_notifications.without_author(profile))
        .to eq [notification_from_someone_else]
    end
  end
end
