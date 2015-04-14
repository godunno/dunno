class Api::V1::Teacher::TopicsController < Api::V1::TeacherApplicationController
  respond_to :json

  def update
    topic.update(topic_params)
    render nothing: true
  end

  def destroy
    topic.destroy
    render nothing: true
  end

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

    def topic_params
      params.require(:topic).permit(:description, :done)
    end

    def topic
      @topic ||= Topic.find_by!(uuid: params[:id])
    end
end
