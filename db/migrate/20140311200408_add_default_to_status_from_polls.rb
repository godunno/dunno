class AddDefaultToStatusFromPolls < ActiveRecord::Migration
  def up
    change_column :polls, :status, :string, default: "available"
  end

  def down
    change_column :polls, :status, :string
  end
end
