class AddWeeklyScheduleToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :weekly_schedule, index: true
  end
end
