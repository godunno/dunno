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
    response_field :read_at, "Timestamp of when the notification was read by user"
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

    let!(:notification_from_himself) do
      create :system_notification, :event_published,
             author: profile,
             profile: profile
    end

    let!(:notification_for_another_user) do
      create(:system_notification, :event_canceled)
    end

    example_request "shows all available notifications for the user", document: :public do
      expect(json).to eq system_notifications: [
        {
          id: new_comment_notification.id,
          notification_type: 'new_comment',
          created_at: new_comment_notification.created_at.utc.iso8601,
          read_at: nil,
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
          id: event_canceled_notification.id,
          notification_type: 'event_canceled',
          created_at: event_canceled_notification.created_at.utc.iso8601,
          read_at: nil,
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
          id: event_published_notification.id,
          notification_type: 'event_published',
          created_at: event_published_notification.created_at.utc.iso8601,
          read_at: nil,
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

  get "/api/v1/system_notifications/:id.json" do
    response_field :created_at, "Timestamp of when the notification was created"
    response_field :read_at, "Timestamp of when the notification was read by user"
    response_field :notification_type, "Event that triggered the notification"
    response_field :name, "Name of the user who generated the notification", scope: :author
    response_field :avatar_url, "Name of the user who generated the notification", scope: :author

    before { Timecop.freeze }

    after { Timecop.return }

    let!(:notification) do
      create(:system_notification, :event_canceled, profile: profile)
    end

    let(:id) { notification.id }

    example_request "sets notification as read", document: :public do
      expect(json).to eq system_notification: {
        id: notification.id,
        created_at: notification.created_at.utc.iso8601,
        notification_type: notification.notification_type,
        read_at: Time.current.utc.change(usec: 0).iso8601,
        author: {
          name: notification.author.name,
          avatar_url: notification.author.avatar_url
        },
        notifiable: {
          start_at: notification.notifiable.start_at.utc.iso8601,
          course: {
            uuid: notification.notifiable.course.uuid,
            name: notification.notifiable.course.name
          }
        }
      }
    end
  end

  post "api/v1/system_notifications/mark_all_as_read.json" do
    response_field :created_at, "Timestamp of when the notification was created"
    response_field :read_at, "Timestamp of when the notification was read by user"
    response_field :notification_type, "Event that triggered the notification"
    response_field :name, "Name of the user who generated the notification", scope: :author
    response_field :avatar_url, "Name of the user who generated the notification", scope: :author

    let(:raw_post) { params.to_json }

    before { Timecop.freeze }

    after { Timecop.return }

    let!(:notification) do
      create(:system_notification, :event_canceled, profile: profile)
    end

    let!(:older_notification) do
      create :system_notification, :event_canceled,
             profile: profile,
             created_at: 1.hour.ago
    end

    example_request "marks all notifications as read", document: :public do
      expect(json).to eq system_notifications: [
        {
          id: notification.id,
          created_at: notification.created_at.utc.iso8601,
          notification_type: notification.notification_type,
          read_at: Time.current.utc.change(usec: 0).iso8601,
          author: {
            name: notification.author.name,
            avatar_url: notification.author.avatar_url
          },
          notifiable: {
            start_at: notification.notifiable.start_at.utc.iso8601,
            course: {
              uuid: notification.notifiable.course.uuid,
              name: notification.notifiable.course.name
            }
          }
        },
        {
          id: older_notification.id,
          created_at: older_notification.created_at.utc.iso8601,
          notification_type: older_notification.notification_type,
          read_at: Time.current.utc.change(usec: 0).iso8601,
          author: {
            name: older_notification.author.name,
            avatar_url: older_notification.author.avatar_url
          },
          notifiable: {
            start_at: older_notification.notifiable.start_at.utc.iso8601,
            course: {
              uuid: older_notification.notifiable.course.uuid,
              name: older_notification.notifiable.course.name
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

    let!(:notification_from_himself) do
      create :system_notification, :event_published,
             author: profile,
             profile: profile
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
