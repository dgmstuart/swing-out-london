# frozen_string_literal: true

# Run with: FROM=2023-12-17 TO=2023-12-25 rails runner scripts/list_socials.rb

from = ENV["FROM"].to_date
to = ENV["TO"].to_date
SocialsListings.new.build(from..to).each do |date, events|
  events_listing = events.reject(&:cancelled?).map(&:title)
  puts I18n.l(date, format: :listing_date)
  events_listing.each { puts "* #{_1}" }
  puts # newline
end
