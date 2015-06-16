class RemoveBeaconIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :beacon_id, :integer
  end
end
