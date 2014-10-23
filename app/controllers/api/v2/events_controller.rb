class Api::V2::EventsController < ActionController::Base
  before_action :find_course

  def index
    @events = @course.events.where(start_at: time_range)
  end

  private

  def find_course
    @course = Course.find(params[:course_id])
  end

  def time_range
    range = Time.zone.now
    range = range.change(year: params[:year].to_i) if params[:year].present?
    range = range.change(month: params[:month].to_i) if params[:month].present?
    range = range.change(day: 1)
    range.all_month
  end
end
