class Api::V1::UsersController < Api::V1::ApplicationController
  def update
    status = if current_user.update(user_params)
               200
             else
               403
             end
    render nothing: true, status: status
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end
end
