class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #ensure_security_headers # See more: https://github.com/twitter/secureheadere

  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :event_pusher_events
  helper_method :course_pusher_events

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :phone_number
  end

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when Teacher then dashboard_teacher_path
    when Student then dashboard_student_path
    else raise "Invalid resource: #{resource_or_scope.inspect}"
    end
  end

  def event_pusher_events
    @event_pusher_events ||= EventPusherEvents.new(current_user)
  end

  def course_pusher_events
    @course_pusher_events ||= CoursePusherEvents.new(current_user)
  end
end
