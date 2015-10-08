class EventCanceledMailer < ActionMailer::Base
  def event_canceled_email(event)
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
    time.strftime('%d/%m/%Y %H:%M')
  end
end
