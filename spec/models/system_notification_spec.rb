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
