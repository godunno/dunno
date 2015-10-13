class CreateSystemNotifications < ActiveRecord::Migration
  def change
    create_table :system_notifications do |t|
      t.belongs_to :author, index: true
      t.belongs_to :profile, index: true
      t.belongs_to :notifiable, polymorphic: true, index: true
      t.integer :notification_type

      t.timestamps
    end
  end
end
