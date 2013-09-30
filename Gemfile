source "https://rubygems.org"

ruby '1.9.3'

gem 'rails', '3.2.14'
gem 'thin'

# Gems used in all environments
gem 'haml'
gem 'haml_rails'
gem 'redcarpet' # markdown
gem 'jquery-rails'

gem 'twitter'

gem 'geocoder'
gem 'gmaps4rails', ">= 2.0.0.pre"

#Caching
gem 'memcachier'
gem 'dalli'
gem 'api_cache'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# To use debugger
# gem 'ruby-debug'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'sqlite3'
  gem 'awesome_print'
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rb-fsevent'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'zeus', '0.13.4.pre2'
  gem 'simplecov'
  gem 'rack-mini-profiler'
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end
