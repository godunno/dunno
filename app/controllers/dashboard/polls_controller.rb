class Dashboard::PollsController < Dashboard::ApplicationController
  def release
    if poll.status == "available"
      poll.update(status: "released")
      EventPusher.new(poll.event).release_poll(poll)
      redirect_to dashboard_events_path
    else
      render json: { errors: [I18n.t('errors.already_released')] }, status: 400
    end
  end

  private
    def poll
      @poll ||= Poll.where(uuid: params[:id]).first!
    end
end
