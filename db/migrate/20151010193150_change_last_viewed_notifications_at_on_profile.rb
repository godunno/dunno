class ChangeLastViewedNotificationsAtOnProfile < ActiveRecord::Migration
  def change
    change_column :profiles, :last_viewed_notifications_at, :datetime, null: true, default: nil
  end
end
