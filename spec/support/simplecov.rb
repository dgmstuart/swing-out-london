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
    group directory.capitalize, "app/#{directory}"
  end
  group "Libraries", "lib"

  %w[config spec].each { skip(_1) }
end
SimpleCov.minimum_coverage 100
