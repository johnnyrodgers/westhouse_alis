# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

	# Helpers
  helper :all # include all helpers, all the time
  
  # Security
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details  
  filter_parameter_logging :password # Scrub sensitive parameters from your log

	# Authentication
  include AuthenticatedSystem
#   
#   # adapted from http://avnetlabs.com/rails/restful-authentication-with-rails-2-usage
#   def access_denied
# 		alias new_session_path login_path
# 		super
# 	end
	
end
