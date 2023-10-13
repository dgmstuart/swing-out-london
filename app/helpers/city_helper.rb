# frozen_string_literal: true

module CityHelper
  def tc(translation_key)
    t(translation_key).fetch(CITY.key)
  end
end
