class AddDurationToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.text :duration
    end
  end
end
