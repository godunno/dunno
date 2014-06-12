# This file is copied to spec/ when you run 'rails generate rspec:install'

if ENV['coverage'] == 'on'
  require 'simplecov'
  SimpleCov.start 'rails' do
    minimum_coverage 100
  end
end

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "email_spec"
require 'shoulda-matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
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
  config.use_transactional_fixtures = true

  config.filter_run wip: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Use the new rspec expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"
  config.render_views
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include Devise::TestHelpers, :type => :controller

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:each) do
    begin_gc_deferment
  end

  config.before(:each, :type => :request) do
    header 'ACCEPT', 'application/json'
    header 'CONTENT_TYPE', 'application/json'
  end

  config.after(:each) do
    scrub_instance_variables
    reconsider_gc_deferment
  end
end

# http://blog.29steps.co.uk/post/24145533872/how-to-optimize-your-rspec-tests
# https://gist.github.com/cheeyeo/790094
# Rspec optmization techniques borrowed from 37Signals

def scrub_instance_variables
  instance_variable_set(:@__memoized, nil)
end


# http://blog.29steps.co.uk/post/24145533872/how-to-optimize-your-rspec-tests
# https://gist.github.com/cheeyeo/790118
# Optimizing the garbage collector in Rspec
DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 1.0).to_f
@@last_gc_run = Time.now

def begin_gc_deferment
  GC.disable if DEFERRED_GC_THRESHOLD > 0
end

def reconsider_gc_deferment
  last_gc_run = self.class.class_variable_get(:@@last_gc_run)
  if DEFERRED_GC_THRESHOLD > 0 && Time.now - last_gc_run >= DEFERRED_GC_THRESHOLD
    GC.enable
    GC.start
    GC.disable

    last_gc_run = Time.now
  end
end
