class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

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
