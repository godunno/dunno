class AddReleasedAtToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :released_at, :datetime
  end
end
