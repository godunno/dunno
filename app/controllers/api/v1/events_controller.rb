class Api::V1::EventsController < ApplicationController
  respond_to :json

  def index
    @events = organization.events
    respond_with @events
  end

  def attend
    if event.opened?
      respond_with event
    else
      render nothing: true, status: 403
    end
  end

  private
    def organization
      @organization ||= Organization.where(uuid: params[:organization_id]).first!
    end

    def event
      @event ||= organization.events.where(uuid: params[:id]).first!
    end

    def event_params
      params.require(:event).permit(:title, :start_at, :organization_id, :status)
    end
end
