# frozen_string_literal: true

require File.expand_path('config/application', __dir__)

task lint_styles: :environment do
  system('yarn run stylelint app/assets/stylesheets')
end

if Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: %i[spec rubocop lint_styles]
end

Swingoutlondon::Application.load_tasks
