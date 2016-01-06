# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.to_a[1..6] << Date::DAYNAMES.to_a[0]

COMPASS_POINTS = %w( C N S E W NE NW SE SW )

LOGINS={
  ENV["SOLDN_USERNAME"] => ENV["SOLDN_PASSWORD_HASH"],
}

# How many socials should be displayed on the index page?
INITIAL_SOCIALS=14

CONTACT_EMAIL = "swingoutlondon@gmail.com"
TWITTER_URL   = "http://www.twitter.com/swingoutlondon"
FACEBOOK_URL  = "https://www.facebook.com/swingoutlondon"
