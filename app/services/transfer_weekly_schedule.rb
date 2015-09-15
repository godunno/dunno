class TransferWeeklySchedule
  attr_reader :weekly_schedule, :attributes
  delegate :course, to: :weekly_schedule
  delegate :valid?, :errors, to: :new_weekly_schedule

  def initialize(options)
    @weekly_schedule = options.fetch(:from)
    @attributes = options.fetch(:to)
  end

  def transfer!
    fail ActiveRecord::RecordInvalid, new_weekly_schedule unless valid?
    ActiveRecord::Base.transaction do
      update_events!
      update_weekly_schedule!
    end
  end

  def affected_events
    return [] if course.events.empty?
    # TODO: Extract to FindAffectedEvents
    @affected_events ||= old_schedule
                         .all_occurrences
                         .map { |occurrence| find_event(occurrence) }
                         .select(&:present?)
  end

  private

  def generate_schedule_for(weekly_schedule, start_time = Time.current)
    IceCube::Schedule.new(start_time) do |s|
      s.add_recurrence_rule weekly_schedule.to_recurrence_rule
    end
  end

  def old_schedule
    @old_schedule ||= generate_schedule_for(weekly_schedule)
  end

  def new_schedule
    return @new_schedule if @new_schedule.present?
    @new_schedule = generate_schedule_for(new_weekly_schedule)
    week = WholePeriod.new(old_schedule.next_occurrence).week
    @new_schedule = generate_schedule_for(new_weekly_schedule, week.begin) unless week.cover?(@new_schedule.next_occurrence)
    @new_schedule
  end

  def time_span
    # TODO: Extract to CalculateTimeSpan
    @time_span ||= next_occurrence_for(new_schedule) - next_occurrence_for(old_schedule)
  end

  def next_occurrence_for(schedule)
    schedule.next_occurrence.change(usec: 0)
  end

  def time_to_i(time)
    Tod::TimeOfDay.parse(time).to_i
  end

  def duration
    @duration ||= time_to_i(new_weekly_schedule.end_time) - time_to_i(new_weekly_schedule.start_time)
  end

  def find_event(occurrence)
    course.events.by_start_at(occurrence.to_time)
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
    @new_weekly_schedule ||= WeeklySchedule.new(weekly_schedule.attributes.merge(@attributes))
  end
end
