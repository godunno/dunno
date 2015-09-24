class Dashboard::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = AuthenticateUserFromFacebook.new(request.env["omniauth.auth"]).authenticate
    sign_in @user, event: :authentication
    redirect_to request.env["omniauth.origin"] || after_sign_in_path_for(@user)
  end
end
