require 'carrierwave/orm/activerecord'

if %w(staging production).include? Rails.env
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',                         # required
      :aws_access_key_id      => ENV['aws_access_key_id'],      # required
      :aws_secret_access_key  => ENV['aws_secret_access_key'],  # required
      #:region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # optional, defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['aws_bucket_name']                  # required
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
