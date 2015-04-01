class Api::V2::EventsController < Api::V2::ApplicationController
  before_action :authenticate_user!, :find_course

  def index
    @events = @course.events.where(start_at: time_range)
  end

  private

  def find_course
    @course = current_profile.courses.find(params[:course_id])
  end

  def time_range
    range = Time.zone.now
    range = range.change(day: 1)
    range = range.change(year: params[:year].to_i) if params[:year].present?
    range = range.change(month: params[:month].to_i) if params[:month].present?
    range.all_month
  end
end
