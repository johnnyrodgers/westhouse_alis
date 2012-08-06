class PresetsController < ApplicationController

  before_filter :login_required

  # GET /presets
  # GET /presets.xml
  def index
  	logger.debug "presets/index called"
    @presets = Preset.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presets }
    end
  end

  # GET /presets/1
  # GET /presets/1.xml
  def show
    @preset = Preset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preset }
    end
  end

  # GET /presets/new
  # GET /presets/new.xml
  def new
    @preset = Preset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preset }
    end
  end

  # GET /presets/1/edit
  def edit
    @preset = Preset.find(params[:id])
  end

  # POST /presets
  # POST /presets.xml
  def create
    @preset = Preset.new(params[:preset])

    respond_to do |format|
      if @preset.save
        flash[:notice] = 'Preset was successfully created.'
        format.html { redirect_to(@preset) }
        format.xml  { render :xml => @preset, :status => :created, :location => @preset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presets/1
  # PUT /presets/1.xml
  def update
    @preset = Preset.find(params[:id])

    respond_to do |format|
      if @preset.update_attributes(params[:preset])
        flash[:notice] = 'Preset was successfully updated.'
        format.html { redirect_to(@preset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presets/1
  # DELETE /presets/1.xml
  def destroy
    @preset = Preset.find(params[:id])
    @preset.destroy

    respond_to do |format|
      format.html { redirect_to(presets_url) }
      format.xml  { head :ok }
    end
  end
end
