# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lindyhop_session',
  :secret      => 'ba622d2776d90f80c36bbbd06f9f83f0aaa21bc014174967a236e859a54b8efc0718f026162dde334bb2037356439420b5c72c80ead9c9b116fbab12e158507b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
