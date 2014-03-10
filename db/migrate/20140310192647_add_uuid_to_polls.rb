class AddUuidToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :uuid, :string
    add_index :polls, :uuid, unique: true
  end
end
