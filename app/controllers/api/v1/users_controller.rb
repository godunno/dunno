class Api::V1::UsersController < Api::V1::ApplicationController
  def update
    if current_user.update(user_params)
      @resource = current_user
      render "api/v1/sessions/#{current_user.profile_name}_sign_in"
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end

  def update_password
    if current_user.update_with_password(password_params)
      sign_in current_user, bypass: true
      @resource = current_user
      render "api/v1/sessions/#{current_user.profile_name}_sign_in"
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
