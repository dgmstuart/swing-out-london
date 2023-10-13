# frozen_string_literal: true

# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.rotate

Rails.application.config.x.donate_link = ENV.fetch("DONATE_LINK", nil)
