class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    @events = organization.events
    respond_with @events, root: false
  end

  def attend
    if event.opened?
      respond_with event, root: false
    else
      render nothing: true, status: 403
    end
  end

  def timeline
    respond_with event
  end

  private
    def organization
      @organization ||= Organization.where(uuid: params[:organization_id]).first!
    end

    def event
      @event ||= organization.events.where(uuid: params[:id]).first!
    end
end
