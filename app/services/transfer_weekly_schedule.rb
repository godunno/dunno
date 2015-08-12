class TransferWeeklySchedule
  attr_reader :weekly_schedule, :attributes
  delegate :course, to: :weekly_schedule

  def initialize(options)
    @weekly_schedule = options.fetch(:from)
    @attributes = options.fetch(:to)
  end

  def transfer!
    ActiveRecord::Base.transaction do
      update_events!
      update_weekly_schedule!
    end
  end

  def affected_events
    @affected_events ||= old_schedule
    .all_occurrences
    .map { |occurrence| find_event(occurrence) }
    .select(&:present?)
  end

  private

  def generate_schedule_for(weekly_schedule)
    IceCube::Schedule.new(Date.current.beginning_of_day) do |s|
      s.add_recurrence_rule weekly_schedule.to_recurrence_rule
    end
  end

  def old_schedule
    @old_schedule ||= generate_schedule_for(weekly_schedule)
  end

  def new_schedule
    @new_schedule ||= generate_schedule_for(new_weekly_schedule)
  end

  def time_span
    @time_spam ||= new_schedule.next_occurrence - old_schedule.next_occurrence
  end

  def time_to_i(time)
    Tod::TimeOfDay.parse(time).to_i
  end

  def duration
    @duration ||=  time_to_i(new_weekly_schedule.end_time) - time_to_i(new_weekly_schedule.start_time)
  end

  def find_event(occurrence)
    Event.find_by(course: course, start_at: occurrence.to_time.change(usec: 0))
  end

  def update_event!(event)
    event.start_at = event.start_at + time_span
    event.end_at = event.start_at + duration
    event.classroom = new_weekly_schedule.classroom
    event.save!
  end

  def update_weekly_schedule!
    weekly_schedule.update!(attributes)
  end

  def update_events!
    affected_events.each { |event| update_event!(event) }
  end

  def new_weekly_schedule
    @new_weekly_schedule ||= WeeklySchedule.new(@attributes.merge(course: course))
  end
end
