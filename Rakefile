# frozen_string_literal: true

require File.expand_path('config/application', __dir__)
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

Swingoutlondon::Application.load_tasks
