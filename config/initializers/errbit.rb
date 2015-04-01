Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_API_KEY']
  config.host    = 'bucket.dunnoapp.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.async do |notice|
    AirbrakeDeliveryWorker.perform_async(notice.to_xml)
  end
end
