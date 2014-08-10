class Api::V1::Teacher::NotificationsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :POST, '/api/v1/teacher/notifications', "Notify a teacher's course."
  def create
    notification = params[:notification]
    course = current_teacher.courses.where(uuid: notification[:course_id]).first

    if course
      SendNotification.new(message: notification[:message], course: course).send!
      render nothing: true
    else
      render nothing: true, status: 400
    end
  end
end
