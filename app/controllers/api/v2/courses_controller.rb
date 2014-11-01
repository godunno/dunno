class Api::V2::CoursesController < ActionController::Base
  def index
    @courses = Course.all
  end
end
