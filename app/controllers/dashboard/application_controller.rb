class Dashboard::ApplicationController < ApplicationController
  before_action :authenticate_user!, except: [:sign_in, :sign_up]
  layout :resolve_layout

  def teacher
    redirect_to dashboard_student_path if current_user.profile.is_a? Student
    render text: '', layout: true
  end

  def student
    redirect_to dashboard_teacher_path if current_user.profile.is_a? Teacher
    render text: '', layout: true
  end

  def sign_in
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end

  def sign_up
  end

  private

    def resolve_layout
      return "sign_in" if action_name.to_s == "sign_up"
      action_name.to_s
    end
end
