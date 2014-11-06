class Api::V2::CoursesController < Api::V2::ApplicationController
  def index
    @courses = Course.all
  end
end
