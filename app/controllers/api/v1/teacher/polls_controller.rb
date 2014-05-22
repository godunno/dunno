class Api::V1::Teacher::PollsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :PATCH, '/api/v1/teacher/polls/:id/release', "Releases the poll on the timeline."
  def release
    if poll.status == "available"
      poll.release!
      EventPusher.new(poll.event).release_poll(poll)
      render nothing: true, status: 200
    else
      render json: { errors: [I18n.t('errors.already_released')] }, status: 304
    end
  end

  private
    def poll
      @poll ||= Poll.where(uuid: params[:id]).first!
    end
end
