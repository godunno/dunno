require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'elasticsearch/rails/instrumentation'

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
    config.autoload_paths << Rails.root.join('lib')

    config.assets.precompile += %w( modernizer.js mailers/base.css )
    config.time_zone = 'Brasilia'
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :"pt-BR"
    config.i18n.locale = :"pt-BR"
    config.beginning_of_week = :sunday

    config.to_prepare do
      %w(app/decorators/**/*_decorator.rb app/form/*.rb).each do |directory|
        Dir.glob(Rails.root + directory).each { |d| require_dependency d }
      end
    end

    config.cache_store = :dalli_store

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    ActionMailer::Base.default(from: 'contato@dunnoapp.com')
  end
end
