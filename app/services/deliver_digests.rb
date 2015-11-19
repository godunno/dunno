class DeliverDigests
  def initialize(users = User.where(receive_digests: true).find_each)
    self.users = users
  end

  def deliver
    users.each do |user|
      profile = user.profile
      notifications = notifications_for(profile)
      next unless notifications.any?
      DigestMailer.delay.digest(profile.id, notifications.map(&:id))
      profile.update!(last_digest_sent_at: Time.current)
    end
  end

  private

  attr_accessor :users

  def notifications_for(profile)
    profile
      .system_notifications
      .more_recent_than(profile.last_digest_sent_at)
  end
end
