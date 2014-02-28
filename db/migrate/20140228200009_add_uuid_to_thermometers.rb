class AddUuidToThermometers < ActiveRecord::Migration
  def change
    add_column :thermometers, :uuid, :string
    add_index :thermometers, :uuid, unique: true
  end
end
