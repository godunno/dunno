Apipie.configure do |config|
  config.app_name                = "Dunno"
  config.api_base_url            = nil
  config.doc_base_url            = "/apipie"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.namespaced_resources = true
end
