# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.1'

gem 'rails', '5.2.1'

gem 'pg'

gem 'puma'

# Gems used in all environments
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'redcarpet' # Markdown

gem 'geocoder'
gem 'gmaps4rails', '2.0.0.pre'

# Caching
gem 'actionpack-action_caching' # to support pre rails-4 style action caching
gem 'dalli'
gem 'memcachier'
gem 'rails-observers' # to support pre rails-4 style cache sweeping

gem 'rack-attack'

gem 'test-unit'

gem 'coffee-rails'
gem 'sassc-rails'
gem 'uglifier'

gem 'bootsnap'

group :development do
  gem 'bullet'
  gem 'listen'
end

group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'fuubar'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rack-mini-profiler', require: false
  gem 'rb-fsevent'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
  gem 'simplecov'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing' # TODO: refactor tests so that we don't need this
  gem 'selenium-webdriver'
  gem 'timecop'
end

gem 'rollbar'
group :production do
  gem 'oj' # For Rollbar
  gem 'rack-canonical-host'
end
