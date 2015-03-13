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
    @tracker ||= Rails.env.test? ? NullTracker.new : Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])
  end

  class NullTracker
    def track(*); end
  end
end
