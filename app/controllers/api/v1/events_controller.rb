class Api::V1::EventsController < ApplicationController
  respond_to :json

  def index
    @events = organization.events
    respond_with @events
  end

  def attend
    respond_with event
  end

  private
    def organization
      @organization ||= Organization.where(uuid: params[:organization_id]).first!
    end

    def event
      organization.events.where(uuid: params[:id]).first!
    end
end
