class CreateCourseFromTemplate
  def initialize(template, teacher:, students: [], start_date: Date.current, weekly_schedules: [])
    self.template = template
    self.teacher = teacher
    self.students = students
    self.start_date = start_date
    self.weekly_schedules = weekly_schedules
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

  def course
    @course ||= Course.create(
      name: template.name,
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
      course.start_date.beginning_of_day..(course.end_date || maximum_course_end_date).end_of_day
    )
  end

  def end_date
    start_date + (template.end_date - template.start_date).to_i.days if template.end_date?
  end

  def maximum_course_end_date
    course.start_date + template.events.count.weeks
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
end
