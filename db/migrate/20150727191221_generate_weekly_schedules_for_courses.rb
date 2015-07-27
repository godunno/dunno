class GenerateWeeklySchedulesForCourses < ActiveRecord::Migration
  def change
    Course.transaction do
      Course.find_each do |course|
        (0..6).each do |weekday|
          unless course.weekly_schedules.detect { |w| w.weekday == weekday }
            WeeklySchedule.create!(weekday: weekday, course: course)
          end
        end
      end
    end
  end
end
