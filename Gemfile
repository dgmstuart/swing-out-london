# frozen_string_literal: true

source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "rails", "~> 7.2.2"

gem "actionpack-action_caching" # to support pre rails-4 style action caching
gem "audited"
gem "bootsnap"
gem "dartsass-rails"
gem "geocoder"
gem "http"
gem "jbuilder"
gem "jsbundling-rails"
gem "memcachier"
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection"
gem "pg"
gem "premailer-rails"
gem "pry-rails"
gem "puma"
gem "rack-attack"
gem "redcarpet" # Markdown
gem "rollbar"
gem "rss"
gem "sprockets-rails"
gem "stimulus-rails"
gem "strip_attributes"
gem "test-unit"
gem "valid_email"

group :development do
  gem "bullet"
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-rails", "2.27.0", require: false
  gem "rubocop-rspec", "3.2.0", require: false
  gem "rubocop-rspec_rails", "2.30.0", require: false
  gem "solargraph-rails"
end

group :test do
  gem "capybara", ">= 3.40"
  gem "climate_control"
  gem "launchy"
  gem "selenium-webdriver", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "vcr"
  gem "webmock"
end

group :production do
  gem "dalli"
  gem "oj" # For Rollbar
  gem "rack-canonical-host"
end
