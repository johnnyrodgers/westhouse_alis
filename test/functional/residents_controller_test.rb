require File.dirname(__FILE__) + '/../test_helper'
require 'residents_controller'

# Re-raise errors caught by the controller.
class ResidentsController; def rescue_action(e) raise e end; end

class ResidentsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :residents

  def setup
    @controller = ResidentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'Resident.count' do
      create_resident
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Resident.count' do
      create_resident(:login => nil)
      assert assigns(:resident).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Resident.count' do
      create_resident(:password => nil)
      assert assigns(:resident).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Resident.count' do
      create_resident(:password_confirmation => nil)
      assert assigns(:resident).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Resident.count' do
      create_resident(:email => nil)
      assert assigns(:resident).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_resident(options = {})
      post :create, :resident => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
