# frozen_string_literal: true

City = Struct.new(:has_facebook_page?)
CITY =
  case ENV.fetch("CITY", "london")
  when "bristol"
    City.new(false)
  else
    City.new(true)
  end
