# frozen_string_literal: true

# Helper methods for wrangling URLs
module Urls
  def strip_redundant_query_params(url)
    return url unless url.start_with?("https://www.facebook.com/events")

    url.split("?", 2).first
  end
end
