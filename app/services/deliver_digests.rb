class DeliverDigests
  def deliver
    User.where(receive_digests: true).find_each do |user|
      profile = user.profile
      next unless has_notifications?(profile)
      DigestMailer.delay.digest(profile)
      profile.update!(last_digest_sent_at: Time.current)
    end
  end

  private

  def has_notifications?(profile)
    profile
      .system_notifications
      .more_recent_than(profile.last_digest_sent_at)
      .any?
  end
end
