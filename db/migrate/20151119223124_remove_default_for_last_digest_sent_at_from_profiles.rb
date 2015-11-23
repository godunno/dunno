class RemoveDefaultForLastDigestSentAtFromProfiles < ActiveRecord::Migration
  def up
    change_column_default :profiles, :last_digest_sent_at, nil
    Profile.find_each do |profile|
      profile.update!(last_digest_sent_at: nil)
    end
  end
end
