class NotifyEventCanceledMail
  def initialize(event)
    self.event = event
  end

  def deliver
    profiles.each do |profile|
      EventCanceledMailer.delay.event_canceled_email(event.id, profile.id)
    end
  end

  private

  attr_accessor :event

  def profiles
    event.course.memberships.map(&:profile)
  end
end
