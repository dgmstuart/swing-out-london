# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.1'

gem 'rails', '5.2.1'

gem 'actionpack-action_caching' # to support pre rails-4 style action caching
gem 'audited'
gem 'bootsnap'
gem 'coffee-rails'
gem 'dalli'
gem 'geocoder'
gem 'gmaps4rails', '2.0.0.pre'
gem 'haml-rails'
gem 'http'
gem 'jquery-rails'
gem 'memcachier'
gem 'omniauth-facebook'
gem 'pg'
gem 'pry-rails'
gem 'puma'
gem 'rack-attack'
gem 'rails-observers' # to support pre rails-4 style cache sweeping
gem 'redcarpet' # Markdown
gem 'rollbar'
gem 'sassc-rails'
gem 'test-unit'
gem 'uglifier'

group :development do
  gem 'bullet'
  gem 'listen'
  gem 'rack-mini-profiler', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rb-fsevent'
  gem 'rspec-rails'
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'climate_control'
  gem 'elabs_matchers'
  gem 'launchy'
  gem 'rails-controller-testing' # TODO: refactor tests so that we don't need this
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'oj' # For Rollbar
  gem 'rack-canonical-host'
end
