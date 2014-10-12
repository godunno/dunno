require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Dunno
  class Application < Rails::Application
    # Do not generate specs for views and requests. Also, do not generate assets.
    config.generators do |g|
      g.helper false
      g.view_specs false
      g.assets false
      g.integration_tool false
    end
    config.app_generators do |g|
      g.test_framework :rspec
    end

    # add custom validators path
    config.autoload_paths += %W["#{config.root}/app/validators/"]

    config.assets.precompile += %w( modernizer.js )
    config.time_zone = 'Brasilia'
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :"pt-BR"
    config.i18n.locale = :"pt-BR"

    config.carrierwave_storage = %w(staging production).include?(::Rails.env) ? :fog : :file

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator.rb").each { |d| require_dependency d }
      Dir.glob(Rails.root + "app/form/*.rb").each { |d| require_dependency d }
    end
  end
end
