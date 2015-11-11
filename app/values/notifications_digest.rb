class NotificationsDigest
  attr_accessor :courses

  def initialize
    self.courses = Set.new
  end

  def <<(system_notification)
    course_digest_for(system_notification) << system_notification
  end

  def courses
    @courses.to_a.sort_by(&:order)
  end

  def ==(other)
    courses == other.courses
  end

  def eql?(other)
    self == other
  end

  delegate :hash, to: :courses

  private

  def course_for(system_notification)
    notifiable = system_notification.notifiable
    case notifiable
    when Course then notifiable
    when Event then notifiable.course
    when Comment then notifiable.event.course
    else raise "Unknown notifiable type: #{notifiable.inspect}"
    end
  end

  def course_digest_for(system_notification)
    course_digest = CourseDigest.new(course_for system_notification)
    @courses << course_digest
    @courses.detect { |c| c == course_digest }
  end
end
