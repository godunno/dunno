class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # ensure_security_headers # See more: https://github.com/twitter/secureheadere

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(_resource_or_scope)
    dashboard_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
