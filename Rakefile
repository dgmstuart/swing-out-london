# frozen_string_literal: true

require File.expand_path('config/application', __dir__)

if Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: %i[spec rubocop]
end

Swingoutlondon::Application.load_tasks
