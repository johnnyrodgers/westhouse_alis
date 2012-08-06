# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_westhouse_session',
  :secret      => 'f63eca1af0492daa94c6f7e950e5ac94cc0d071da5409b3808f8bf4130ec92c54887f036eb7230233f9277adab74632a9abd164329af4d114e206e1135f5f2f6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
