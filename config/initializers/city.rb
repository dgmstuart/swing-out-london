# frozen_string_literal: true

City = Struct.new(:key, :has_facebook_page?)
CITY =
  case ENV.fetch("CITY", "london")
  when "bristol"
    City.new(:bristol, false)
  else
    City.new(:london, true)
  end
