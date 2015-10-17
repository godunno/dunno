class AddReadAtToSystemNotifications < ActiveRecord::Migration
  def change
    add_column :system_notifications, :read_at, :timestamp
  end
end
