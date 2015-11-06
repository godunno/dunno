class AddBlockedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :blocked_at, :datetime
  end
end
