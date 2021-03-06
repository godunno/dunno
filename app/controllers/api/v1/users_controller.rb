class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :skip_authorization, only: [:update, :update_password]
  def update
    current_user.update!(user_params)
    @resource = current_user
    render "api/v1/sessions/user_sign_in"
  end

  def update_password
    if current_user.update_with_password(password_params)
      sign_in current_user, bypass: true
      @resource = current_user
      TrackerWrapper.new(current_user).track("Password Changed", page: "Profile")
      render "api/v1/sessions/user_sign_in"
    else
      render json: { errors: current_user.errors.details }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :receive_digests)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
