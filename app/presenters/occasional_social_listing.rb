# frozen_string_literal: true

class OccasionalSocialListing < SocialListing
  def highlight?
    false
  end

  def map_url(_date)
    nil # The map currently only shows the next 14 days
  end
end
