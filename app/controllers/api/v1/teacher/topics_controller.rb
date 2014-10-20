class Api::V1::Teacher::TopicsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :PATCH, '/api/v1/teacher/topics/:id/transfer',
      "Transfer a topic to the next event."
  def transfer
    next_event = topic.event.next
    if next_event
      topic.update!(timeline: next_event.timeline)
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
