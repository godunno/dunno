class Dashboard::UsersController < Devise::RegistrationsController
  respond_to :json, :html

  def create
    ActiveRecord::Base.transaction do
      super do |user|
        user.update(profile: Student.new)
        user.valid? && TrackerWrapper.new(user).track('Student Signed Up')
      end
    end
  end

  def accept_invitation
    @user = User.find_by(invitation_token: params[:invitation_token])
    if @user.nil? || Invitation.new(@user).expired?
      render nothing: true, status: 401
    else
      sign_in(@user)
    end
  end

  def update
    if current_user.update(update_params)
      RegistrationsMailer.delay.successful_registration(current_user.id)
      sign_in current_user, bypass: true
      render nothing: true, status: 200
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end

  protected

  def update_params
    params.require(:user).permit(:password)
  end

  def sign_up(*)
    super
    RegistrationsMailer.delay.successful_registration(current_user.id)
  end
end
