class BuildDigest
  def initialize(profile, system_notifications)
    self.profile = profile
    self.system_notifications = system_notifications
  end

  def notifications
    NotificationsDigest.new.tap do |result|
      system_notifications.map do |system_notification|
        result << system_notification
      end
    end
  end

  private

  attr_accessor :profile, :system_notifications
end
