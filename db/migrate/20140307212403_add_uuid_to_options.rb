class AddUuidToOptions < ActiveRecord::Migration
  def change
    add_column :options, :uuid, :string
    add_index :options, :uuid, unique: true
  end
end
