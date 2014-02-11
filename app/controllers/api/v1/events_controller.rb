class Api::V1::EventsController < ApplicationController
  respond_to :json
  respond_to :html, only: [:new, :index]

  def index
    @events = organization.events
    respond_with @events
  end

  def new
    @event = Event.new(organization: organization)
  end

  def create
    @event = Event.new(event_params)
    @event.save
    redirect_to action: :index
  end

  def edit
    @event = event
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

    def event_params
      params.require(:event).permit(:title, :start_at, :organization_id, :status)
    end
end
