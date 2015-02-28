class TrackerWrapper
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def track(event, parameters = {})
    tracker.track(user.id, event, parameters)
  end

  private

  def tracker
    @tracker ||= Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])
  end
end
