# frozen_string_literal: true

# Class which can be used to build canonical URLs using the URL helpers defined
# in the routes.
#
# This is useful for writing objects which are truly isolated from Rails (which
# makes for nice fast specs) but also ensures that we generate canonical URLs
# in the event that multiple valid URLs resolve to the site.
class UrlHelpers
  include Rails.application.routes.url_helpers

  def default_url_options
    { protocol: "https", host: ENV.fetch("CANONICAL_HOST") }
  end
end
