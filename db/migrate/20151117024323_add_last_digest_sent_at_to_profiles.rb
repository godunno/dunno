class AddLastDigestSentAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :last_digest_sent_at, :datetime, default: Time.zone.local(2015, 10, 01)
  end
end
