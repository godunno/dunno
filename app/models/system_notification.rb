class SystemNotification < ActiveRecord::Base
  enum notification_type: %w(
                              event_canceled
                              event_published
                              new_comment
                              blocked
                              promoted_to_moderator
                              new_member
                              new_topic
                            )

  belongs_to :author, class_name: 'Profile'
  belongs_to :profile
  belongs_to :notifiable, polymorphic: true

  validates :author, :profile, :notifiable, :notification_type, presence: true
  validate :notifiable_matches_notification_type

  default_scope { order(created_at: :desc) }

  scope :more_recent_than, -> (datetime) { datetime ? where('created_at > ?', datetime) : all }
  scope :without_author, -> (author) { where.not(author: author) }

  private

    def notifiable_matches_notification_type
      return unless notification_type.present?
      errors.add(:notifiable, :doesnt_match) unless notifiable.is_a?(
        case notification_type
        when 'event_canceled', 'event_published' then Event
        when 'new_comment' then Comment
        when 'blocked', 'new_member', 'promoted_to_moderator' then Course
        when 'new_topic' then Topic
        end
      )
    end
end
