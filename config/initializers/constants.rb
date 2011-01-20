# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.to_a[1..6] << Date::DAYNAMES.to_a[0]

COMPASS_POINTS = %w( C N S E W NE NW SE SW )

LOGINS={
  "dgms" => "12fc8b7edab94448559b7ac12ee2b8bb",
}

# How many socials should be displayed on the index page?
INITIAL_SOCIALS=14

# For how many days can an event be considered 'New'?
NEW_DAYS = 1.month

CONTACT_EMAIL = "leveretweb@googlemail.com"