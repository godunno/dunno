class TopicsFor
  def initialize(event, profile)
    self.event = event
    self.profile = profile
  end

  def topics
    if profile.role_in(event.course) == 'teacher'
      event.topics
    else
      event.topics.without_personal
    end
  end

  private

  attr_accessor :event, :profile
end
