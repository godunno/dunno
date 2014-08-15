class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_teacher!
  skip_before_filter :authenticate_teacher!, only: [:sign_in]
  layout :resolve_layout

  def index
    render text: '', layout: true
  end

  def sign_in
  end

  private
    def resolve_layout
      case action_name.to_s
      when "index" then "dashboard"
      when "sign_in" then "sign_in"
      else raise "Invalid action: #{action_name}"
      end
    end
end
