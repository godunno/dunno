class Api::V1::Teacher::NotificationsController < Api::V1::TeacherApplicationController
  respond_to :json

  def create
    notification = params[:notification]
    course = current_teacher.courses.find_by!(uuid: notification[:course_id])
    course.update!(abbreviation: params[:notification][:abbreviation])
    send_notification = SendNotification.new(message: notification[:message], course: course)
    send_notification.call
    if send_notification.valid?
      render nothing: true
    else
      render json: { errors: send_notification.errors }, status: 403
    end
  end
end
