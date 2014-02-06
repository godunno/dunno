class ChangeTimelineUserMessagesRelation < ActiveRecord::Migration
  def change
    remove_column :timeline_user_messages, :timeline_id
  end
end
