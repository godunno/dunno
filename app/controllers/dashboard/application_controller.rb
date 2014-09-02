class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, only: [:sign_in]
  layout :resolve_layout

  def teacher
    render text: '', layout: true
  end

  def student
    render text: '', layout: true
  end

  def sign_in
  end

  private
    def resolve_layout
      action_name.to_s
    end
end
