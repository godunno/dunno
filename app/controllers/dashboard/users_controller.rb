class Dashboard::UsersController < Devise::RegistrationsController
  respond_to :json, :html

  def create
    ActiveRecord::Base.transaction do
      super do |user|
        user.update!(profile: Student.new)
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
    safe_parameters = params.required(:user).permit(:password)
    if current_user.update(safe_parameters)
      RegistrationsMailer.delay.successful_registration(current_user.id, safe_parameters[:password])
      sign_in current_user, bypass: true
      render nothing: true, status: 200
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end

  protected

  def sign_up(*)
    super
    RegistrationsMailer.delay.successful_registration(current_user.id, params[:user][:password])
  end
end
