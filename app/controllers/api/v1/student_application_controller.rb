class Api::V1::StudentApplicationController < Api::V1::ApplicationController
  helper_method :current_student

  def current_student
    current_user.profile
  end
end
