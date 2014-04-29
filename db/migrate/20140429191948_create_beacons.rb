class CreateBeacons < ActiveRecord::Migration
  def change
    create_table :beacons do |t|
      t.uuid :uuid
      t.integer :major, limit: 8
      t.integer :minor, limit: 8
      t.string :title

      t.timestamps
    end

    add_index :beacons, :uuid, unique: true
  end
end
