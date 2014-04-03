class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #ensure_security_headers # See more: https://github.com/twitter/secureheadere

  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :pusher_events

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def current_user
    current_student || current_teacher
  end

  def pusher_events
    @pusher_events ||= PusherEvents.new(current_user)
  end
end
