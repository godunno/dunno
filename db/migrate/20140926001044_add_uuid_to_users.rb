class AddUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :uuid
    add_index :users, :uuid, unique: true
  end
end
