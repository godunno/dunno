class RenameTimelineUserMessagesToTimelineMessages < ActiveRecord::Migration
  def change
    rename_table :timeline_user_messages, :timeline_messages
  end
end
