class Api::V1::RatingsController < Api::V1::ApplicationController
  respond_to :json

  def create
    rating = Rating.new(params[:rating])
    rating.student = current_student
    rating.rateable = thermometer
    rating.save
    render nothing: true, status: 201
  end

  private
    def thermometer
      @thermometer ||= Thermometer.where(uuid: params[:thermometer_id]).first!
    end
end
