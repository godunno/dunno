class PromotedToModeratorNotification
  def initialize(course, student)
    self.course = course
    self.student = student
  end

  def deliver
    SystemNotification.create!(
      profile: student,
      author: course.teacher,
      notifiable: course,
      notification_type: 'promoted_to_moderator'
    )
  end

  private

  attr_accessor :course, :student
end

