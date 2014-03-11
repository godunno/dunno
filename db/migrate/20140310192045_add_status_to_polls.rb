class AddStatusToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :status, :string
  end
end
