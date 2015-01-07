class Api::V1::UsersController < Api::V1::ApplicationController
  def update
    if current_user.update(user_params)
      @resource = current_user
      profile_name = current_user.profile.class.name.downcase
      render "api/v1/sessions/#{profile_name}_sign_in"
    else
      render nothing: true, status: 403
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end
end
