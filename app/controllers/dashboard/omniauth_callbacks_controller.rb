class Dashboard::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if (@user = AuthenticateUserFromFacebook.new(request.env["omniauth.auth"]).authenticate)
      sign_in @user, event: :authentication
      redirect_to request.env["omniauth.origin"] || after_sign_in_path_for(@user)
    else
      redirect_to user_omniauth_authorize_path(
        provider: :facebook,
        auth_type: :rerequest,
        scope: :email
      )
    end
  end
end
