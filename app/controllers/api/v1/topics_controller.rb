class Api::V1::TopicsController < Api::V1::ApplicationController
  respond_to :json

  def create
    authorize event, :update?
    @topic = Topic.new(event: event)
    TopicForm.new(@topic, create_params).create!(event)
    render status: :created
  end

  def update
    authorize topic.event, :update?
    TopicForm.new(topic, update_params).update!
  end

  def destroy
    authorize topic.event, :update?
    topic.destroy
    render nothing: true
  end

  # TODO: Transfer as the first topic
  def transfer
    authorize topic.event, :update?
    service = TransferTopic.new(topic)
    if service.transfer
      status = 200
    else
      status = 422
    end
    render nothing: true, status: status
  end

  private

  def create_params
    params.require(:topic).permit(:description, :personal, :media_id)
  end

  def update_params
    params.require(:topic).permit(:description, :done, :personal)
  end

  def topic
    @topic ||= Topic.find_by!(uuid: params[:id])
  end

  def course_params
    params.require(:topic).require(:event).require(:course).permit(:uuid)
  end

  def course
    @course ||= current_profile.courses.find_by!(course_params)
  end

  def event_params
    params.require(:topic).require(:event).permit(:start_at, :order)
  end

  def event
    @event ||= FindOrInitializeEvent.by(course, event_params)
  end
end
