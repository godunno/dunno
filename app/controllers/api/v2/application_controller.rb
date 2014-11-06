class Api::V2::ApplicationController < ActionController::Base
  helper_method :current_user
  respond_to :json

  def current_user
    @current_user ||= User.find(@_current_user_id) if @_current_user_id
  rescue ActiveRecord::RecordNotFound
    @_current_user_id = nil
    nil
  end

  def authenticate_user!
    authenticate_or_request_with_http_token do |token, _options|
      api_key = ApiKey.find_by(token: token)
      if api_key
        @_current_user_id = api_key.user_id
      end
    end
  end

  def authenticate_user_with_credentials!
    authenticate_or_request_with_http_basic do |email, password|
      user = User.find_by(email: email)
      user && user.valid_password?(password) && @_current_user_id = user.id
    end
  end
end
