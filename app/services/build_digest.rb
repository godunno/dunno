class BuildDigest
  def initialize(profile)
    self.profile = profile
  end

  def deliver
    DigestMailer.delay.digest(profile, notifications)
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
    profile.system_notifications.where('created_at > ?', 1.day.ago)
  end
end
