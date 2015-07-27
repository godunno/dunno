class GenerateUuidForWeeklySchedules < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      WeeklySchedule.find_each do |weekly_schedule|
        weekly_schedule.update!(uuid: UuidGenerator.new(weekly_schedule).generate)
      end
    end
  end
end
