class Api::V1::TeacherApplicationController < Api::V1::ApplicationController
  helper_method :current_teacher

  def current_teacher
    current_user.profile
  end
end
