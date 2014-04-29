class AddBeaconIdToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :beacon, index: true
  end
end
