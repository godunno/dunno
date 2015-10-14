class EventCanceledMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout 'email'

  def event_canceled_email(event)
    @event_link = path_for(event)
    @start_at = format_time(event.start_at)
    @course = event.course
    mail to: recipients_for(event), subject: subject_for(event)
  end

  private

  def recipients_for(event)
    event.course.memberships.map do |membership|
      membership.profile.email
    end
  end

  def subject_for(event)
    "[Dunno] Aula cancelada: #{event.course.name} - #{format_time(event.start_at)}"
  end

  def format_time(time)
    l(time, format: '%A (%d/%b – %H:%M)')
  end

  def path_for(event)
    "/dashboard#/courses/#{event.course.uuid}/events?month=#{event.start_at.utc.iso8601}"
  end
end
