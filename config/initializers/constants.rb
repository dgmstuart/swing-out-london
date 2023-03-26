# frozen_string_literal: true

# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.rotate

CONTACT_EMAIL = "swingoutlondon@gmail.com"

Rails.application.config.x.donate_link = ENV["DONATE_LINK"]
