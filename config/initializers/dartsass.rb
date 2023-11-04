# frozen_string_literal: true

Rails.application.configure do
  config.dartsass.builds = {
    "application.scss" => "application.css",
    "application_cms.scss" => "application_cms.css"
  }
  config.dartsass.build_options =
    if Rails.env.development?
      "--style=compressed --embed-sources"
    else
      "--style=compressed --no-source-map"
    end
end
