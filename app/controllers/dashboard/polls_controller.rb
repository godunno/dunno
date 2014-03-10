class Dashboard::PollsController < Dashboard::ApplicationController
  def release
    poll.update(status: "released")
    EventPusher.new(poll.event).release_poll(poll)
    render nothing: true, status: 200
  end

  private
    def poll
      @poll ||= Poll.where(uuid: params[:id]).first!
    end
end
