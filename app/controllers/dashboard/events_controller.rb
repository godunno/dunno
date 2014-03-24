class Dashboard::EventsController < Dashboard::ApplicationController
  respond_to :html, only: [:new, :edit, :index]

  def index
    @events = course.events
    respond_with @events
  end

  def new
    @event = Event.new
    @event.topics.build
    @event.thermometers.build
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

  def open
    event.update_attributes(status: 'opened')
    redirect_to action: :index
  end

  def close
    event.update_attributes(status: 'closed', closed_at: DateTime.now)
    EventPusher.new(event).close
    redirect_to action: :index
  end

  private

    def event
      @event ||= Event.where(uuid: params[:id]).first!
    end

    def course
      @course ||= Course.where(uuid: params[:course_id]).first!
    end

    def event_params
      params.require(:event).permit(
        :title, :start_at, :duration, :status,
        topics_attributes: [:id, :description, :_destroy],
        thermometers_attributes: [:id, :content, :_destroy],
        polls_attributes: [:id, :content, :status, :_destroy,
          options_attributes: [:id, :content, :correct, :_destroy]
        ],
        personal_notes_attributes: [:id, :content, :_destroy]
      )
    end
end
