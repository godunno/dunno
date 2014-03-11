class Api::V1::RatingsController < Api::V1::ApplicationController
  respond_to :json

  def create
    rating = Rating.new(rating_params)
    rating.student = current_student
    rating.rateable = thermometer
    rating.save
    render json: "{}", status: 201
  end

  private
    def thermometer
      @thermometer ||= Thermometer.where(uuid: params[:thermometer_id]).first!
    end

    def rating_params
      params.require(:rating).permit(:value)
    end
end
