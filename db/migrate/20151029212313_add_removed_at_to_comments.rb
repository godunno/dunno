class AddRemovedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :removed_at, :datetime
  end
end
