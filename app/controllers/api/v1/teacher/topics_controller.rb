class Api::V1::Teacher::TopicsController < Api::V1::TeacherApplicationController
  respond_to :json

  def transfer
    next_event = topic.event.next
    if next_event
      topic.update!(event: next_event)
      status = 200
    else
      status = 422
    end
    render nothing: true, status: status
  end

  private

    def topic
      @topic ||= Topic.find_by!(uuid: params[:id])
    end
end
