class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # ensure_security_headers # See more: https://github.com/twitter/secureheadere

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def after_sign_in_path_for(resource_or_scope)
      profile = resource_or_scope.profile
      case profile
      when Teacher then dashboard_teacher_path
      when Student then dashboard_student_path
      else raise "Invalid profile: #{profile.inspect}"
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
      devise_parameter_sanitizer.for(:sign_up) << :phone_number
    end
end
