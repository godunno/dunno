Jumpup::Heroku.configure do |config|
  config.staging_app = 'dunnovc-staging'
  config.production_app = 'dunnovc'
end if Rails.env.development?