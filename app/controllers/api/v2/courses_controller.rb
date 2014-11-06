class Api::V2::CoursesController < Api::V2::ApplicationController
  before_action :authenticate_user!

  def index
    @courses = current_profile.courses
  end
end
