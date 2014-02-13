class AddDurationToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.time :duration
    end
  end
end
