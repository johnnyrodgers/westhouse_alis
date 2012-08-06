class Preset < ActiveRecord::Base

 	def settings
 		# create settings hash
	 	settings = Hash.new 	 	
		# populate settings
		settings = {
			:preset => self.id,
			:hvac => { 
				:thermostat_main => self.thermostat_main,
				:thermostat_loft => self.thermostat_loft,
				:thermostat_bathroom => self.thermostat_bathroom,
				:thermostat_garage => self.thermostat_garage
			},
			:lights => {
				:garage_sign => self.garage_sign,
				:west_flood => self.west_flood,
				:west_entry => self.west_entry,
				:balcony => self.balcony,
				:garage_interior => self.garage_interior,
				:living_dimmer => self.living_dimmer,
				:dining_dimmer => self.dining_dimmer,
				:stairs => self.stairs,
				:loft => self.loft,
				:kitchen => self.kitchen,
				:bathroom => self.bathroom,
				:bathroom_mirror => self.bathroom_mirror,
				:bedside_lamps => self.bedside_lamps,
				:hallway => self.hallway				
			},
			:ambient_canvas => {
				:ac_pwm_a => self.ac_pwm_a
			}
		}
	end

end
