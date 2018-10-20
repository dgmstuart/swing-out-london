# frozen_string_literal: true

# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.to_a[1..6] << Date::DAYNAMES.to_a[0]

COMPASS_POINTS = %w[C N S E W NE NW SE SW].freeze

LOGINS = {
  ENV['SOLDN_USERNAME'] => ENV['SOLDN_PASSWORD_HASH'],
  ENV['SOLDN_SUPPORT_USER_1_USERNAME'] => ENV['SOLDN_SUPPORT_USER_1_PASSWORD_HASH']
}.freeze

# How many socials should be displayed on the index page?
INITIAL_SOCIALS = 14

CONTACT_EMAIL = 'swingoutlondon@gmail.com'
TWITTER_URL   = 'https://www.twitter.com/swingoutlondon'
FACEBOOK_URL  = 'https://www.facebook.com/swingoutlondon'
