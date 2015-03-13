class CopyClassroomFromWeeklySchedulesToEvents < ActiveRecord::Migration
  def change
    Event.find_each do |event|
      start_time = event.start_at.strftime "%H:%M"
      end_time = event.end_at.strftime "%H:%M"
      weekday = event.start_at.wday

      next if event.course.nil?
      weekly_schedule = event.course.weekly_schedules.detect do |w|
        w.start_time == start_time && w.end_time == end_time && w.weekday == weekday
      end

      next if weekly_schedule.nil?
      event.classroom = weekly_schedule.classroom
      event.save!
    end
  end
end
