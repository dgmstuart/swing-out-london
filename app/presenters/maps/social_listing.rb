# frozen_string_literal: true

module Maps
  # Presenter for displaying {Event}s with social dances as listings on the Map.
  class SocialListing < ::SocialListing
    delegate(
      :has_class?,
      :has_taster?,
      :class_style,
      :class_organiser,
      to: :event
    )
  end
end
