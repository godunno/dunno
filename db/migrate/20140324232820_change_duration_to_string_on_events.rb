class ChangeDurationToStringOnEvents < ActiveRecord::Migration
  def change
    change_column :events, :duration, :string
  end
end
