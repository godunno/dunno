class Dashboard::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if (@user = AuthenticateUserFromFacebook.new(request.env["omniauth.auth"]).authenticate)
      sign_in @user, event: :authentication
      redirect_to redirect_to_from_params || origin || after_sign_in_path_for(@user)
    else
      redirect_to user_omniauth_authorize_path(
        provider: :facebook,
        auth_type: :rerequest,
        scope: :email
      )
    end
  end

  private

    def redirect_to_from_params
      request.env["omniauth.params"]["redirectTo"].presence
    end

    def origin
      request.env["omniauth.origin"]
    end
end
