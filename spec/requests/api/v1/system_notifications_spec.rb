require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Events" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let(:user_email) { profile.email }
  let(:user_token) { profile.authentication_token }

  let(:json) { JSON.parse(response_body).deep_symbolize_keys }
  let!(:profile) { create(:profile) }

  get "/api/v1/system_notifications.json" do
    response_field :created_at, "Timestamp of when the notification was created"
    response_field :notification_type, "Event that triggered the notification"
    response_field :name, "Name of the user who generated the notification", scope: :author
    response_field :avatar_url, "Name of the user who generated the notification", scope: :author

    let!(:notification) do
      create(:system_notification, :event_canceled, profile: profile)
    end
    let!(:older_notification) do
      create :system_notification, :event_canceled,
        profile: profile,
        created_at: 1.hour.ago
    end
    let!(:notification_for_another_user) do
      create(:system_notification, :event_canceled)
    end

    example_request "shows all available notifications for the user", document: :public do
      expect(json).to eq system_notifications: [
        {
          created_at: notification.created_at.utc.iso8601,
          notification_type: notification.notification_type,
          author: {
            name: notification.author.name,
            avatar_url: notification.author.avatar_url
          }
        },
        {
          created_at: older_notification.created_at.utc.iso8601,
          notification_type: older_notification.notification_type,
          author: {
            name: older_notification.author.name,
            avatar_url: older_notification.author.avatar_url
          }
        }
      ]
    end
  end
end
