class Dashboard::ApplicationController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:sign_in]
  layout :resolve_layout

  def teacher
    render text: '', layout: true
  end

  def student
    render text: '', layout: true
  end

  def sign_in
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end

  private

    def resolve_layout
      action_name.to_s
    end
end
