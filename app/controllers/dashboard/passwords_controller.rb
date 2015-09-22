class Dashboard::PasswordsController < Devise::PasswordsController
  layout "sign_in"
  respond_to :json
end
