class Dashboard::EventsController < Dashboard::ApplicationController
  respond_to :html, only: [:new, :edit, :index]

  def index
    @events = if course
                course.events
              else
                current_teacher.events
              end
    respond_with @events
  end

  def new
    @event = Event.new
  end

  def create
    Event.transaction do
      @event = Event.new(event_params)
      %w(medias polls topics thermometers).each do |attr|
        send("#{attr}_params")["#{attr}_attributes"].try(:each) do |i, artifact_params|
          artifact = attr.singularize.capitalize.constantize.new(artifact_params)
          artifact.timeline = @event.timeline
          artifact.teacher = current_teacher
          artifact.save!
        end
      end
      @event.save
    end
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
    event.close!
    EventPusher.new(event).close
    redirect_to action: :index
  end

  private

  def event
    @event ||= Event.where(uuid: params[:id]).first
  end

  def course
    @course ||= Course.where(uuid: params[:course_id]).first
  end

  def topics_params
    params[:event].permit(topics_attributes: [:id, :description, :_destroy])
  end

  def polls_params
    params[:event].permit(polls_attributes: [:id, :content, :status, :_destroy,
                          options_attributes: [:id, :content, :correct, :_destroy]])
  end

  def thermometers_params
    params[:event].permit(thermometers_attributes: [:id, :content, :_destroy])
  end

  def medias_params
    params[:event].permit(medias_attributes: [:id, :title, :description, :url, :category, :file, :_destroy])
  end

  def event_params
    params.require(:event).permit(
      :title, :start_at, :duration, :status,
      personal_notes_attributes: [:id, :content, :_destroy]
    )
  end
end
