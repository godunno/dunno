class Api::V1::EventsController < ApplicationController
  respond_to :json

  def index
    @events = organization.events
    respond_with @events
  end

  private
    def organization
      @organization ||= Organization.where(id: params[:organization_id]).first!
    end
end
