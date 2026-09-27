# frozen_string_literal: true

Rails.application.configure do
  config.dartsass.builds = {
    "application.scss" => "application.css",
    "application_cms.scss" => "application_cms.css",
    "mail.scss" => "mail.css"
  }
  config.dartsass.build_options =
    if Rails.env.development?
      %w[--style=compressed --embed-sources --load-path=node_modules]
    else
      %w[--style=compressed --no-source-map --load-path=node_modules]
    end
end
