class AddUuidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :uuid, :string
    add_index :events, :uuid, unique: true
  end
end
