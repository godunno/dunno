class Api::V1::Teacher::NotificationsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :POST, '/api/v1/teacher/notifications', "Notify a teacher's course."
  def create
    notification = params[:notification]
    course = current_teacher.courses.where(uuid: notification[:course_id]).first
    send_notification = SendNotification.new(message: notification[:message], course: course)
    send_notification.call
    if send_notification.valid?
      render nothing: true
    else
      render json: { errors: send_notification.errors }, status: 403
    end
  end
end
