class NewMemberNotification
  def initialize(course, student)
    self.course = course
    self.student = student
  end

  def deliver
    SystemNotification.create!(
      profile: course.teacher,
      author: student,
      notifiable: course,
      notification_type: 'new_member'
    )
  end

  private

  attr_accessor :course, :student
end
