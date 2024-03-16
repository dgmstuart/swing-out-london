# frozen_string_literal: true

class UrlHelpers
  include Rails.application.routes.url_helpers

  def default_url_options
    { protocol: "https", host: ENV.fetch("CANONICAL_HOST") }
  end
end
