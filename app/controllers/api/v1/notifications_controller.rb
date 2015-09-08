class Api::V1::NotificationsController < Api::V1::ApplicationController
  respond_to :json

  def create
    course_id, abbreviation, message = params[:notification].values_at(:course_id, :abbreviation, :message)
    course = current_profile.courses.find_by!(uuid: course_id)
    authorize course, :send_notification?
    course.update!(abbreviation: abbreviation)
    send_notification = SendNotification.new(message: message, course: course)
    send_notification.call
    render nothing: true
  end
end
