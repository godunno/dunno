require 'spec_helper'

RSpec.describe SystemNotification, type: :model do
  let(:system_notification) { build(:system_notification, :event_canceled) }

  describe "association" do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:notifiable) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:profile) }
    it { is_expected.to validate_presence_of(:notifiable) }
    it { is_expected.to validate_presence_of(:notification_type) }
  end

  describe "#notification_type" do
    it "allows valid notification types" do
      %w(event_canceled event_published new_comment).each do |notification_type|
        expect {
          system_notification.notification_type = notification_type
        }.not_to raise_error
      end
    end

    it "doesn't allow invalid notification type" do
      expect {
        system_notification.notification_type = 'invalid'
      }.to raise_error(ArgumentError)
    end
  end

  describe "#author" do
    it "associates with profile as author" do
      profile = create(:profile)
      expect {
        system_notification.update!(author: profile)
      }.not_to raise_error
    end
  end

  describe "#notifiable" do
    it "associates polymorphically with any model" do
      expect {
        system_notification.update!(notifiable: create(:event))
      }.not_to raise_error

      expect {
        system_notification.update!(notifiable: create(:comment))
      }.not_to raise_error
    end
  end
end
