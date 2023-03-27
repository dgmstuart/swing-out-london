# frozen_string_literal: true

module Map
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
