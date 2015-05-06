class Api::V1::Teacher::TopicsController < Api::V1::TeacherApplicationController
  respond_to :json

  def create
    event = current_teacher.events.find(create_params.delete(:event_id))
    @topic = Topic.new
    TopicForm.new(@topic, create_params).create!(event)
    render status: :created
  end

  def update
    TopicForm.new(topic, update_params).update!
  end

  def destroy
    topic.destroy
    render nothing: true
  end

  # TODO: Transfer as the first topic
  def transfer
    next_event = topic.event.next_not_canceled
    if next_event
      topic.update!(event: next_event)
      status = 200
    else
      status = 422
    end
    render nothing: true, status: status
  end

  private

    def create_params
      params.require(:topic).permit(:description, :personal, :media_id, :event_id)
    end

    def update_params
      params.require(:topic).permit(:description, :done, :personal)
    end

    def topic
      @topic ||= Topic.find_by!(uuid: params[:id])
    end
end
