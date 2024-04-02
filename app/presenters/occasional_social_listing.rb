# frozen_string_literal: true

# Presenter for displaying {Event}s with social dances as occasional listings.
class OccasionalSocialListing < SocialListing
  def highlight?
    false
  end

  def map_url(_date)
    nil # The map currently only shows the next 14 days
  end
end
