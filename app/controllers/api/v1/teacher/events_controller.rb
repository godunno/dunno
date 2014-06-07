class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    respond_with Event.all
  end

  def show
    respond_with event
  end

  def create
    # TODO: [URGENT] Extract to form object!
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
    render nothing: true
  end

  def update
    event.update_attributes(event_params)
    render nothing: true
  end

  def destroy
    event.destroy
    render nothing: true
  end

  api :PATCH, '/api/v1/teacher/events/:id/open', "Opens the event so students can attend to it."
  def open
    if event.opened?
      render nothing: true, status: 304
    else
      event.open!
      CoursePusher.new(event).open
      respond_with event
    end
  end

  api :PATCH, '/api/v1/teacher/events/:id/close', "Closes the event and releases the thermometers."
  def close
    if event.closed?
      render nothing: true, status: 304
    else
      event.close!
      EventPusher.new(event).close
      render json: "{}", status: 200
    end
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
