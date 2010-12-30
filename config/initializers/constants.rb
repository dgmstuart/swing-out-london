# Days of the week starting Monday
DAYNAMES = Date::DAYNAMES.to_a[1..6] << Date::DAYNAMES.to_a[0]

COMPASS_POINTS = %w( C N S E W NE NW SE SW )

LOGINS={
  "dgms" => "879851e2ad3d62ceceed2f74f2242ea8",
  "lancep" => "9a261213120510fcb48bb27d300f9815"
}

# How many socials should be displayed on the index page?
INITIAL_SOCIALS=14

# For how many days can an event be considered 'New'?
NEW_DAYS = 1.month

CONTACT_EMAIL = "leveretweb@googlemail.com"