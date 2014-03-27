class Api::V1::Teacher::PollsController < Api::V1::TeacherApplicationController
  respond_to :json

  def release
    if poll.status == "available"
      poll.update(status: "released")
      EventPusher.new(poll.event).release_poll(poll)
      render json: "{}", status: 200
    else
      render json: { errors: [I18n.t('errors.already_released')] }, status: 400
    end
  end

  private
    def poll
      @poll ||= Poll.where(uuid: params[:id]).first!
    end
end
