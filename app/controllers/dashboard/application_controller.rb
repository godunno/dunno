class Dashboard::ApplicationController < ApplicationController
  def index
    render text: '', layout: true
  end

  def sign_in
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    else
      render layout: 'sign_in'
    end
  end

  def sign_up
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    else
      render layout: 'sign_in'
    end
  end
end
