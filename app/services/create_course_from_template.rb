class CreateCourseFromTemplate
  def initialize(template, teacher:, name: nil, students: [], start_date: Date.current, end_date: nil, weekly_schedules: [])
    self.template = template
    self.teacher = teacher
    self.name = name
    self.students = students
    self.start_date = start_date
    self.weekly_schedules = weekly_schedules
    self.end_date = end_date
  end

  def create
    template.events.each_with_index do |template_event, index|
      event = schedule.events[index]
      event.topics = template_event.topics.map(&dup_topic)
      event.status = template_event.status
      event.classroom = template_event.classroom
      event.save!
    end

    course
  end

  private

  attr_accessor :template, :teacher, :students, :start_date, :weekly_schedules
  attr_writer :name
  attr_reader :end_date

  def course
    @course ||= Course.create(
      name: name,
      teacher: teacher,
      students: students,
      weekly_schedules: weekly_schedules,
      start_date: start_date,
      end_date: end_date
    )
  end

  def schedule
    CourseScheduler.new(
      course,
      course.start_date.beginning_of_day..maximum_course_end_date.end_of_day
    )
  end

  def name
    @name ||= template.name
  end

  def maximum_course_end_date
    start_date.to_date + template.events.count.weeks
  end

  def dup_topic
    -> (topic) do
      new_topic = topic.dup

      new_topic.media = dup_media(new_topic.media) if new_topic.media.present?

      new_topic
    end
  end

  def dup_media(media)
    media.dup.tap { |m| m.profile = teacher }
  end

  def end_date=(value)
    if value.nil? && template.end_date?
      value = start_date.to_date + (template.end_date - template.start_date).to_i.days
    end

    value = maximum_course_end_date if value.present? && value.to_date < maximum_course_end_date 

    @end_date = value
  end
end
