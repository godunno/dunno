class Api::V1::ApplicationController < ApplicationController
  include Pundit

  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  helper_method :current_profile

  protected

  def current_profile
    current_user.profile
  end

  alias_method :pundit_user, :current_profile

  private

  def render_invalid_record(exception)
    notify_airbrake exception
    render json: { errors: exception.record.errors.details }, status: 422
  end

  # Solution given on:
  # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end
end
