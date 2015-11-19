class BuildDigest
  def initialize(profile)
    self.profile = profile
  end

  def notifications
    NotificationsDigest.new.tap do |result|
      system_notifications.map do |system_notification|
        result << system_notification
      end
    end
  end

  private

  attr_accessor :profile

  def system_notifications
    profile.system_notifications.more_recent_than(profile.last_digest_sent_at)
  end
end
