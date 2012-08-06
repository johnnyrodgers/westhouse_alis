module AuthenticatedTestHelper
  # Sets the current resident in the session from the resident fixtures.
  def login_as(resident)
    @request.session[:resident_id] = resident ? residents(resident).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
