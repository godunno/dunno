class EventCanceledMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  layout 'email'

  def event_canceled_email(event_id, profile_id)
    event = Event.find(event_id)
    profile = Profile.find(profile_id)

    @event_link = path_for(event)
    @start_at = format_time(event.start_at)
    @course = event.course
    roadie_mail to: profile.email, subject: subject_for(event)
  end

  private

  def subject_for(event)
    "[Dunno] Aula cancelada: #{event.course.name} - #{format_time(event.start_at)}"
  end

  def format_time(time)
    l(time, format: '%A (%d/%b – %H:%M)')
  end

  def path_for(event)
    params = { startAt: event.start_at.utc.iso8601, trackEventCanceled: true }
    "/dashboard#/courses/#{event.course.uuid}/events?#{params.to_param}"
  end
end
