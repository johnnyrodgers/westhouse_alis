class ResidentsController < ApplicationController
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    @resident = Resident.new(params[:resident])
    @resident.save
    if @resident.errors.empty?
      self.current_resident = @resident
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def login
  	
  end

end
