class Api::V1::ConfigsController < Api::V1::ApplicationController
  respond_to :json

  def show
    render json: SHARED_CONFIG
  end
end
