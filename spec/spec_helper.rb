# This file is copied to spec/ when you run 'rails generate rspec:install'

if ENV['coverage'] == 'on'
  require 'simplecov'
  SimpleCov.start 'rails' do
    minimum_coverage 100
  end
end

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
ActiveRecord::Migration.maintain_test_schema!

require 'rspec/rails'
require 'email_spec'
require 'shoulda-matchers'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  config.filter_run wip: true
  config.run_all_when_everything_filtered = true

  # Use the new rspec expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"
  config.render_views
  config.include Rack::Test::Methods, type: :request
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include AuthRequestHelpers, type: :request

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:each, type: :request) do
    header 'ACCEPT', 'application/json'
    header 'CONTENT_TYPE', 'application/json'
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def app
  Rails.application
end
