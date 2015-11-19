class AddReceiveDigestsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_digests, :boolean, default: true
    add_index :users, :receive_digests
  end
end
