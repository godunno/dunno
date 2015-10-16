require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "SystemNotifications" do
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

    let(:course) { create(:course) }
    let(:event) { create(:event, course: course) }
    let(:comment) { create(:comment, event: event) }

    let!(:new_comment_notification) do
      create :system_notification, :new_comment,
             profile: profile,
             notifiable: comment
    end

    let!(:event_canceled_notification) do
      create :system_notification, :event_canceled,
             profile: profile,
             created_at: 1.hour.ago,
             notifiable: event
    end

    let!(:event_published_notification) do
      create :system_notification, :event_published,
             profile: profile,
             created_at: 2.hours.ago,
             notifiable: event
    end

    let!(:notification_for_another_user) do
      create(:system_notification, :event_canceled)
    end

    example_request "shows all available notifications for the user", document: :public do
      expect(json).to eq system_notifications: [
        {
          created_at: new_comment_notification.created_at.utc.iso8601,
          notification_type: 'new_comment',
          author: {
            name: new_comment_notification.author.name,
            avatar_url: new_comment_notification.author.avatar_url
          },
          notifiable: {
            id: comment.id,
            event: {
              start_at: event.start_at.utc.iso8601,
              course: {
                uuid: course.uuid,
                name: course.name
              }
            }
          }
        },
        {
          created_at: event_canceled_notification.created_at.utc.iso8601,
          notification_type: 'event_canceled',
          author: {
            name: event_canceled_notification.author.name,
            avatar_url: event_canceled_notification.author.avatar_url
          },
          notifiable: {
            start_at: event.start_at.utc.iso8601,
            course: {
              uuid: course.uuid,
              name: course.name
            }
          }
        },
        {
          created_at: event_published_notification.created_at.utc.iso8601,
          notification_type: 'event_published',
          author: {
            name: event_published_notification.author.name,
            avatar_url: event_published_notification.author.avatar_url
          },
          notifiable: {
            start_at: event.start_at.utc.iso8601,
            course: {
              uuid: course.uuid,
              name: course.name
            }
          }
        }
      ]
    end
  end

  get "/api/v1/system_notifications/new_notifications.json" do
    response_field :new_notifications_count,
                   "How many new system notifications since the user last viewed them"

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

    before do
      profile.update!(last_viewed_notifications_at: 1.minute.ago)
    end

    example_request "shows all available notifications for the user", document: :public do
      expect(json).to eq new_notifications_count: 1
    end
  end

  patch "/api/v1/system_notifications/viewed.json" do
    let(:raw_post) { params.to_json }

    before do
      Timecop.freeze(Time.zone.local(2015, 10, 10, 15, 00))
      profile.update!(last_viewed_notifications_at: 1.hour.ago)
    end

    after { Timecop.return }

    example_request "updates the current profile's last_viewed_notifications_at",
                    document: :public do
      expect(profile.reload.last_viewed_notifications_at).to eq Time.current
    end
  end
end
