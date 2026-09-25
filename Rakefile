# frozen_string_literal: true

require File.expand_path("config/application", __dir__)

if Rails.env.local?
  require "rubocop/rake_task"
  RuboCop::RakeTask.new

  task lint_styles: :environment do
    system("yarn stylelint") || exit($CHILD_STATUS.exitstatus)
  end

  task erb_lint: :environment do
    system("bundle exec erb_lint --lint-all") || exit($CHILD_STATUS.exitstatus)
  end

  task default: %i[spec rubocop erb_lint lint_styles]
end

Swingoutlondon::Application.load_tasks
