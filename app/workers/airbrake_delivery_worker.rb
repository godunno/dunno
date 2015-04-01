class AirbrakeDeliveryWorker
  include Sidekiq::Worker
  include Airbrake

  def perform(notice)
    Airbrake.sender.send_to_airbrake notice
  end
end
