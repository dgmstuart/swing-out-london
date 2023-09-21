# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.1"

gem "rails", "~> 6.1.7", ">= 6.1.7.5"

gem "actionpack-action_caching" # to support pre rails-4 style action caching
gem "audited"
gem "bootsnap"
gem "coffee-rails"
gem "geocoder"
gem "haml-rails"
gem "http"
gem "jbuilder"
gem "jsbundling-rails"
gem "memcachier"
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection"
gem "pg"
gem "pry-rails"
gem "puma"
gem "rack-attack"
gem "redcarpet" # Markdown
gem "rollbar"
gem "rss"
gem "sassc-rails"
gem "sprockets"
gem "stimulus-rails"
gem "strip_attributes"
gem "test-unit"
gem "turbo-rails"

group :development do
  gem "bullet"
  gem "listen"
  gem "rack-mini-profiler", require: false
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rb-fsevent"
  gem "rspec-rails"
  gem "rubocop", "~> 1.51.0", require: false
  gem "rubocop-capybara", "2.18.0", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "capybara"
  gem "climate_control"
  gem "elabs_matchers"
  gem "launchy"
  gem "rails-controller-testing" # TODO: refactor tests so that we don't need this
  gem "selenium-webdriver", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "vcr"
  gem "webmock"
end

group :production do
  gem "connection_pool"
  gem "dalli"
  gem "oj" # For Rollbar
  gem "rack-canonical-host"
end
