class Dashboard::EventsController < Dashboard::ApplicationController
  respond_to :html, only: [:new, :edit, :index]

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
    event
  end

  def update
    event.update_attributes(event_params)
    redirect_to action: :index
  end

  def destroy
    event.destroy
    redirect_to action: :index
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
