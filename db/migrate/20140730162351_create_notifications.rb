class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.belongs_to :course, index: true
    end
  end
end
