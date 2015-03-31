class Api::V1::Teacher::NotificationsController < Api::V1::TeacherApplicationController
  respond_to :json

  def create
    notification = params[:notification]
    course = current_teacher.courses.find_by!(uuid: notification[:course_id])
    course.update!(abbreviation: params[:notification][:abbreviation])
    send_notification = SendNotification.new(message: notification[:message], course: course)
    send_notification.call
    render nothing: true
  end
end
