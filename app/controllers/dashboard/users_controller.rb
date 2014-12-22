class Dashboard::UsersController < Devise::RegistrationsController
  def create
    ActiveRecord::Base.transaction do
      super do |user|
        profile = params["user"]["profile"]
        user.profile = case profile
                       when "teacher" then Teacher.new
                       when "student" then Student.new
                       else raise "Invalid profile: #{profile}"
                       end
        user.save!
      end
    end
  end

  def accept_invitation
    @user = User.find_by(invitation_token: params[:invitation_token])
    if @user.nil? || Invitation.new(@user).expired?
      render nothing: true, status: 401
    else
      sign_in(@user)
      redirect_to "/dashboard/teacher#/courses?first_access=true"
    end
  end

  def update
    safe_parameters = params.required(:user).permit(:password)
    if current_user.update(safe_parameters)
      sign_in current_user, bypass: true
      render nothing: true, status: 200
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end
end
