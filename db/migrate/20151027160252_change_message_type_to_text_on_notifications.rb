class ChangeMessageTypeToTextOnNotifications < ActiveRecord::Migration
  def up
    change_column :notifications, :message, :text
  end

  def down
    change_column :notifications, :message, :string
  end
end
