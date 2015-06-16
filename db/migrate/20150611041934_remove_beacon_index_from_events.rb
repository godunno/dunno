class RemoveBeaconIndexFromEvents < ActiveRecord::Migration
  def change
    remove_index :events, :beacon_id
  end
end
