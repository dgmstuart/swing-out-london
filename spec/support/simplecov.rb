# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  %w[
    controllers
    models
    helpers
    services
    presenters
    forms
    validators
    concerns
  ].each do |directory|
    add_group directory.capitalize, "app/#{directory}"
  end
  add_group "Libraries", "lib"

  %w[config spec].each { add_filter(_1) }
end
SimpleCov.minimum_coverage 100
