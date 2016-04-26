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
      event.topics = template_event.topics.map(&:dup)
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

      # TODO: test course without end_date
      end_date: start_date + (template.end_date - template.start_date).to_i.days
    )
  end

  def schedule
    CourseScheduler.new(course, course.start_date..course.end_date)
  end
end
