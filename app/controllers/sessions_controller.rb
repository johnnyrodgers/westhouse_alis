# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    self.current_resident = Resident.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_resident.remember_me unless current_resident.remember_token?
        cookies[:auth_token] = { :value => self.current_resident.remember_token , :expires => self.current_resident.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
    	flash.now[:error] = "Login unsuccessful.  Please try again."
      render :action => 'new'
    end
  end

  def destroy
  	
    self.current_resident.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
end
