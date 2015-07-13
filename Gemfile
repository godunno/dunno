source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails',                      '4.1.6'
gem 'unicorn',                    '4.8.3'
gem 'secure_headers',             '2.0.0'
gem 'jquery-rails',               '3.1.2'
gem 'slim-rails',                 '3.0.1'
gem 'jbuilder',                   '2.3.1'
gem 'pg',                         '0.18.2'
gem 'sass-rails',                 '5.0.3'
gem 'coffee-rails',               '4.1.0'
gem 'uglifier',                   '2.7.1'
gem 'rack-canonical-host',        '0.1.0'
gem 'devise',                     '3.5.1'
gem 'rabl',                       '0.11.6'
gem 'oj',                         '2.12.9'
# TODO: Replace both with https://github.com/seejohnrun/ice_cube
gem 'tod',                        '1.5.0'
gem 'recurrence',                 '1.3.0'
gem 'virtus',                     '1.0.5'
gem 'twilio-ruby',                '4.2.1'
gem 'foundation-rails',           '5.5.2.1'
gem 'roboto',                     '0.2.0'
gem 'newrelic_rpm',               '3.12.1.298'
gem 'link_thumbnailer',           '2.5.2'
gem 'acts-as-taggable-on',        '3.5.0'
gem 'elasticsearch-model',        '0.1.6'
gem 'elasticsearch-rails',        '0.1.6'
gem 'sidekiq',                    '3.4.1'
gem 'will_paginate',              '3.0.7'
gem 'roadie-rails',               '1.0.6'
gem 'autoprefixer-rails',         '5.2.1'
gem 'devise-async',               '0.9.0'
gem 'intercom-rails',             '0.2.27'
gem 'active_model-errors_details','1.1.0'
gem 'phonie',                     '3.1.12'
gem 'dalli',                      '2.7.4'
gem 'google_drive',               '1.0.0', require: false
gem 'mixpanel-ruby',              '2.1.0'
gem 'carrierwave',                '0.10.0'
gem 'fog',                        '1.32.0'
gem 'airbrake',                   '4.3.0'
gem 'pundit',                     '1.0.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-angular',       '1.3.16'
  gem 'rails-assets-angular-resource', '1.3.16'
  gem 'rails-assets-angular-mocks', '1.3.16'
  gem 'rails-assets-angularjs-rails-resource', '1.2.1'
  gem 'rails-assets-angular--bower-angular-i18n', '1.3.11'
  gem 'rails-assets-angular-animate', '1.3.16'
  gem 'rails-assets-angular-messages', '1.3.16'
  gem 'rails-assets-modernizr', '2.8.3'
  gem 'rails-assets-jquery-maskedinput', '1.4.0'
  gem 'rails-assets-angular-ui-sortable', '0.13.0'
  gem 'rails-assets-arktisklada--jquery-ui-touch-punch', '0.2.3'
  gem 'rails-assets-ng-file-upload',      '1.6.12'
  gem 'rails-assets-ng-file-upload-shim', '1.6.12'
  gem 'rails-assets-lunks--ngTagsInput', '3.0.0'
  gem 'rails-assets-angular-elastic-input', '2.0.2'
  gem 'rails-assets-angular-validation-match', '1.3.0'
  gem 'rails-assets-angular-input-masks', '2.0.0'
  gem 'rails-assets-angular-foundation', '0.5.1'
  gem 'rails-assets-angular-busy', '4.1.2'
  gem 'rails-assets-lunks--angulartics', '0.18.0'
  gem 'rails-assets-scrollmagic', '2.0.5'
  gem 'rails-assets-greensock', '1.17.0'
  gem 'rails-assets-ui-router', '0.2.15'
  gem 'rails-assets-angular-filter', '0.5.4'
end

group :production, :staging do
  gem 'rails_12factor',            '0.0.3'
  gem 'memcachier',                '0.0.2'
  gem 'bonsai-elasticsearch-rails','0.0.4'
end

gem 'database_cleaner',           '1.4.1',     require: false

group :development do
  gem 'pronto',                   '0.4.2'
  gem 'pronto-rubocop',           '0.4.4'
  gem 'pronto-flay',              '0.4.1'
  gem 'pronto-scss',              '0.4.6',     require: false
  gem 'rubocop',                  '0.32.1'
  gem 'foreman',                  '0.78.0'
  gem 'letter_opener',            '1.4.1'
end

group :test do
  gem 'shoulda-matchers',         '2.8.0',     require: false
  gem 'simplecov',                '0.10.0',     require: false
  gem 'email_spec',               '1.6.0'
  gem 'capybara',                 '2.4.4',     require: false
  gem 'selenium-webdriver',       '2.45.0',    require: false
  gem 'capybara-angular',         '0.1.1',     require: false
  gem 'connection_pool'
end

group :development, :test do
  gem 'rspec-rails',              '3.3.2'
  gem 'factory_girl_rails',       '4.5.0'
  gem 'pry-rails',                '0.3.4'
  gem 'dotenv-rails',             '1.0.2'
  gem 'vcr',                      '2.9.3'
  gem 'webmock',                  '1.20.4'
  gem 'timecop',                  '0.7.1'
  gem 'rspec_api_documentation',  '4.3.0'
  gem 'teaspoon-jasmine',         '2.2.0'
end
