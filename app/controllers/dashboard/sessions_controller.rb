class Dashboard::SessionsController < Devise::SessionsController
  layout "sign_in"
  def new
    super
  end
end
