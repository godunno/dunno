class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_teacher!

  def index
    render text: '', layout: true
  end
end
