source 'http://rubygems.org'

gem 'rails', '3.0.3'

gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'twitter'

gem 'geokit'

# Hosting on heroku
gem 'heroku'
gem 'taps'


# To use debugger
# gem 'ruby-debug'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
   #gem 'webrat'
   gem 'rspec-rails'
   gem 'factory_girl_rails', '~> 1.2'
   gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
   gem 'guard-rspec'
   gem 'guard-livereload'
end
