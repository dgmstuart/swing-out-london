source "https://rubygems.org"

ruby "2.3.3"

gem 'rails', '5.0.7'

gem "pg", '< 1.0'

gem "puma"

# Gems used in all environments
gem "haml"
gem "haml-rails"
gem "redcarpet" # Markdown
gem "jquery-rails"

gem "geocoder"
gem "gmaps4rails", "2.0.0.pre"

#Caching
gem "memcachier"
gem "dalli"
gem "actionpack-action_caching" # to support pre rails-4 style action caching
gem "rails-observers" # to support pre rails-4 style cache sweeping

gem "rack-attack"

gem 'test-unit'

gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

group :development do
  gem "bullet"
  gem "listen"
end

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "rb-fsevent"
  gem "simplecov"
  gem "rack-mini-profiler", require: false
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara", "< 3.0"
  gem "launchy"
  gem "ffaker"
  gem "fuubar"
end

group :test do
  gem 'timecop'
  gem 'rails-controller-testing' # TODO: refactor tests so that we don't need this
end

gem "rollbar"
group :production do
  gem 'oj' # For Rollbar
  gem "rack-canonical-host"
end

