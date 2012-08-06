class ControlsController < ApplicationController

  #before_filter :login_required, :except => [:push_subscription, :push_logout, :push_relaunch]
	
	def central
		# assign instance variables
		@client_id = "central"
		@presets = Preset.find(:all)
		@links = Link.find(:all, :conditions => { :panel => "central" })
		@status = populate_status		
	end

	def bedroom
		# assign instance variables
		@client_id = "bedroom"
		@presets = Preset.find(:all)
		@status = populate_status
		@links = Link.find(:all, :conditions => { :panel => "bedroom" })
		render :layout => "controls_secondary"
	end

	def garage
		# assign instance variables
		@client_id = "garage"
		@presets = Preset.find(:all)
		@status = populate_status
		@links = Link.find(:all, :conditions => { :panel => "garage" })
		render :layout => "controls_secondary"
	end	
	
	def populate_status
		# get current light status from datalogs.lightstatus table
		lightstatus = Control.find(:first).attributes
		# set defaults based on Home preset
		defaults = Preset.find_by_name("Home")
		# populate status hash
		status = {
			:preset => 0,
			:hvac => {
				:thermostat_main => defaults.thermostat_main,
				:thermostat_loft => defaults.thermostat_loft,
				:thermostat_bathroom => defaults.thermostat_bathroom,
				:thermostat_garage => defaults.thermostat_garage
			},
			:lights => lightstatus,
			:ambient_canvas => { 
				:ac_pwm_a =>	defaults.ac_pwm_a
			}
		}
		return status	
	end

	def update_status
    params["status"].each do |key, value|
      # look up device name from DEVICES List
      device_name = DEVICES.index(key)
      # populate javascript to send   
      if device_name.include? "dimmer" # DIMMERS
        javascript = "setSliderPosition('#{device_name}', #{value});"
      else # TOGGLES
        javascript = "setTogglePosition('#{device_name}', #{value});"
      end
      # send updates to all clients
      Juggernaut.show_clients.each do |client|
        Juggernaut.send_to_client("#{javascript}", "#{client['client_id']}")
      end
    end
    render :nothing => true
  end

	# MCONTROL
	def sendCommand
		service = MControl_x0020_Web_x0020_ServiceSoap.new    
		#service.sendCommand(SendCommand.new(params[:device_id], "#{params[:command]}"))
		logger.debug "sending command to mControl: #{params[:command]}"
		sleeper
		render :nothing => true
	end

	# used to buffer commands to mControl at 200ms intervals - prevents overload of the mServer buffer
	def sleeper
		sleep(0.2)
	end	
	
	# AMBIENT CANVAS
  def ac_channels
    # create channels array
  	channels = [
  	  {:id => 1, :device => "ac_pwm_a"},
  	  {:id => 2, :device => "ac_pwm_a"},
  	  {:id => 3, :device => "ac_pwm_a"},
  	  {:id => 4, :device => "ac_pwm_a"},
  	  {:id => 5, :device => "ac_pwm_a"},
  	  {:id => 6, :device => "ac_pwm_a"},
  	  {:id => 7, :device => "ac_pwm_a"},
  	  {:id => 8, :device => "ac_pwm_a"},
  	  {:id => 1, :device => "ac_pwm_b"},
  	  {:id => 2, :device => "ac_pwm_b"},
  	  {:id => 3, :device => "ac_pwm_b"},
  	  {:id => 4, :device => "ac_pwm_b"},
  	  {:id => 5, :device => "ac_pwm_b"},
  	  {:id => 6, :device => "ac_pwm_b"}
  	]
  	return channels
  end

	def switchAmbientCanvas
		#set up service
		service = MControl_x0020_Web_x0020_ServiceSoap.new    
		# get channels array
		channels = ac_channels
		# set intensity limit
		if params[:command] == "ON" then duty = 255 else duty = 0 end
    # iterate over channels
		channels.each do |channel|
			#service.sendCommand(SendCommand.new(DEVICES[channel[:device]], "SETPWM #{duty} #{channel[:id]}"))
			sleeper
		end
		render :nothing => true
	end            
	      
	def ac_test
		# set params
		duty = params[:duty]
		channel = params[:channel]
		ms = params[:ms]
		logger.debug "Duty: " + duty.to_s
		logger.debug "Channel: " + channel.to_s
		logger.debug "Milliseconds: " + ms.to_s
		#set up service
		service = MControl_x0020_Web_x0020_ServiceSoap.new   
    # set default flash message
		flash.now[:notice] = ""
		# SET ALL
		if channel == "ALL"
  		channels = ac_channels  		
  		channels.each do |channel|
  			#service.sendCommand(SendCommand.new(DEVICES[channel[:device]], "SETPWM #{duty} #{channel[:id]}"))
				flash.now[:notice] += "SETPWM " + duty + " " + channel[:id].to_s + " " + ms + "<br />" 
  			sleeper
  		end
		elsif !duty.nil?
			if (1..8).include?(channel.to_i)
				#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_a"], "SETPWM #{duty} #{channel}"))
				flash.now[:notice] = "SETPWM " + duty + " " + channel + " " + ms 	
			elsif (1..6).include?(channel.to_i)
				#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_b"], "SETPWM #{duty} #{channel}"))
				flash.now[:notice] = "SETPWM " + duty + " " + channel + " " + ms 
			end				
		end
		render :layout => false
	end
	
	def ac_test_pattern
		id = params[:id].to_i
		#set up service
		service = MControl_x0020_Web_x0020_ServiceSoap.new   
		# run chosen pattern
		case id
			when 1
				# UPWARD MOTION
				logger.debug "UPWARD MOTION TEST PATTERN"
				duty = 255
				ms = 100
				5.times do 
					(1..8).each do |channel|
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_a"], "SETPWM #{duty} #{channel}"))
						logger.debug "SETPWM " + duty.to_s  + " " + channel.to_s + " " + ms.to_s
						sleep(ms / 1000.0)
					end
					(1..6).each do |channel|
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_b"], "SETPWM #{duty} #{channel}"))
						logger.debug "SETPWM " + duty.to_s  + " " + channel.to_s + " " + ms.to_s
						sleep(ms / 1000.0)
					end
					(1..8).each do |channel|
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_a"], "SETPWM 0 #{channel}"))
						logger.debug "SETPWM 0 " + channel.to_s + " 0"
					end
					(1..6).each do |channel|
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_b"], "SETPWM 0 #{channel}"))
						logger.debug "SETPWM 0 " + channel.to_s + " 0"
					end
				end
			when 2
				# RANDOM PULSES
				logger.debug "RANDOM PULSES TEST PATTERN"
				60.times do 
					duty = rand(256)
					channel = rand(15)
					ms = rand(3001)
					if (1..8).include?(channel)
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_a"], "SETPWM #{duty} #{channel}"))
						logger.debug "SETPWM " + duty.to_s  + " " + channel.to_s + " " + ms.to_s
						sleep(0.5)
					elsif (9..14).include?(channel)
					  channel = channel - 8
						#service.sendCommand(SendCommand.new(DEVICES["ac_pwm_b"], "SETPWM #{duty} #{channel}"))
						logger.debug "SETPWM " + duty.to_s  + " " + channel.to_s + " " + ms.to_s
						sleep(0.5)
					end
				end
			when 3
				# SLOW PULSE
			
		end		
		render :text => "Rendering Test Pattern #{id}..."
	end

	# JUGGERNAUT (PUSH SERVER)
	def push
		#check_threads
		# create clients array
		clients = []
		# populate clients array (only add clients that did not originate the push request: avoids needlessly updating the originator - which leads to jitter)
		Juggernaut.show_clients.each do |client|
			# adjust parameter based on platform: client["id"] on *nix and client["client_id"] on windows
			if client["id"].nil?
				if client["client_id"] != params[:client_id]
					clients << client["client_id"]
				end
			else 
				if client["id"] != params[:client_id]
					clients << client["id"]
				end
			end
		end
		if params["controls"]
			logger.debug "CONTROLS: " + params["controls"].to_yaml
			# parse JSON parameters into a controls Hash
			controls = JSON.parse(params["controls"])
			# push new values to each touch panel
			clients.each do |client|
				#Juggernaut.send_to_client("updateControls(#{JSON.generate(controls)}, true, false, '#{client}')", "#{client}")
				# changed JSON call after reading http://osdir.com/ml/RubyonRailsTalk/2009-07/msg02830.html
				Juggernaut.send_to_client("updateControls(#{controls.to_json}, true, false, '#{client}')", "#{client}")
			end
		else 
			# push javascript to be rendered to clients
			#Juggernaut.send_to_clients(params["javascript"], clients) # this doesn't work on Windows due to conflict with to_json method as defined the JSON gem and ActiveSupport
			clients.each do |client|
				Juggernaut.send_to_client(params["javascript"], "#{client}")
			end
    end
		render :nothing => true
	end

	# these methods are needed by Juggernaut but don't have any content because all they require is a valid HTTP 200 code back
	def push_subscription
		render :nothing => true
	end
	
	def push_logout
		render :nothing => true
	end

	# calls Juggernaut initializer to relaunch it on error	
	def push_relaunch
		require "config/initializers/launch_juggernaut.rb"
		render :nothing => true
	end  	
	  
end
