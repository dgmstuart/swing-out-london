source "https://rubygems.org"

ruby "2.3.3"

gem 'rails', '>= 4.0.0', '< 4.1'

gem "pg", '< 1.0'

# Gems used in all environments
gem "haml"
gem "haml-rails"
gem "redcarpet" # Markdown
gem "jquery-rails"

gem "geocoder"
gem "gmaps4rails", "2.0.0.pre"

gem "strong_parameters"

#Caching
gem "memcachier"
gem "dalli"

gem "rack-attack"
gem "figaro"

gem 'test-unit'

gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

group :development do
  gem "bullet", '< 5'
end

group :development, :test do
  gem "awesome_print"
  gem "pry-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "rb-fsevent"
  gem "simplecov"
  gem "rack-mini-profiler"
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara"
  gem "launchy"
  gem "ffaker"
  gem "fuubar"
end

group :test do
  gem 'timecop'
end

gem "rollbar"
group :production do
  gem "unicorn"
  gem "newrelic_rpm"
  gem 'oj' # For Rollbar
  gem "rack-canonical-host"
end

