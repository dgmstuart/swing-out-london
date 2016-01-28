source "https://rubygems.org"

ruby "2.2.3"

gem 'rails', '~> 3.2.22'

gem "pg", "~> 0.17"

# Gems used in all environments
gem "haml", "~> 4.0"
gem "haml-rails", "~> 0.4"
gem "redcarpet", "~> 3.0" # Markdown
gem "jquery-rails", "~> 3.0"

gem "twitter", "~> 5.15"

gem "geocoder", "~> 1.2"
gem "gmaps4rails", "2.0.0.pre"

gem "strong_parameters"

#Caching
gem "memcachier", "~> 0.0"
gem "dalli", "~> 2.7"
gem "api_cache", "~> 0.2"

gem "figaro", "~> 0.7"

gem 'test-unit', '~> 3.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails", "~> 3.2"
  gem "coffee-rails", "~> 3.2"
  gem "uglifier", "~> 2.2"
end

group :development do
  gem "bullet"
end

group :development, :test do
  gem "awesome_print", "~> 1.2"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.2"
  gem "factory_girl_rails", "~> 4.2"
  gem "rb-fsevent", "~> 0.9"
  gem "guard-rspec"
  gem "zeus", "~> 0.13"
  gem "simplecov", "~> 0.7"
  gem "rack-mini-profiler", ">= 0.9.1"
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara"
  gem "ffaker"
  gem "fuubar"
end

group :production do
  gem "unicorn", "~> 4.8.3"
  gem "newrelic_rpm", "~> 3.6"
  gem "rack-canonical-host"
end

