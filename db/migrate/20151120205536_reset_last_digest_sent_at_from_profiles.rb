class ResetLastDigestSentAtFromProfiles < ActiveRecord::Migration
  def up
    Profile.find_each do |profile|
      profile.update!(last_digest_sent_at: Time.current)
    end
  end
end
