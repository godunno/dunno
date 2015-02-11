if Rails.env.staging? || Rails.env.production?
  Airbrake.configure do |config|
    config.api_key = ENV['ERRBIT_API_KEY']
    config.host    = 'bucket.dunnoapp.com'
    config.port    = 80
    config.secure  = config.port == 443
  end
end
