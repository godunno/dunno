class Dashboard::PollsController < Dashboard::ApplicationController
  def release
    poll.update(status: "released")
    EventPusher.new(poll.event).release_poll(poll)
    redirect_to dashboard_organization_events_path(poll.event.organization.uuid)
  end

  private
    def poll
      @poll ||= Poll.where(uuid: params[:id]).first!
    end
end
