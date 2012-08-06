//updateControls() accepts a controls hash and updates all controls on the client and updates the window.controls hash
//pulsate and start are flags indicating whether to pulsate the control on change, and whether to set a value on start or not, respectively
function updateControls(controls, pulsate, start, panel) {
	//assign existing controls to temporary variable
	existingControls = recursive_clone(window.controls);
	//set pulsate default value (true)
	var pulsate = (typeof pulsate == 'undefined') ? true : pulsate;
	//set start default value (false)
	var start = (typeof start == 'undefined') ? false : start;
	//HVAC
	for (var thermostat in controls.hvac) {
		//check if element is in DOM (interface-dependent)
		if ($(thermostat + "_up_down") != null) {
			setTemperature(thermostat, controls.hvac[thermostat], pulsate);
		}			
	}		
	//LIGHTS
	for (var light in controls.lights) {
		// DIMMERS
		if (light.indexOf("dimmer") != -1) {
			//check if element is in DOM (interface-dependent)
			if ($(light) != null) {
				setSliderPosition(light, controls.lights[light]);
			}
		}
		// TOGGLES
		else {
			//check if element is in DOM (interface-dependent)
			if ($(light) != null) {
				setTogglePosition(light, controls.lights[light]);
			}
		}
	}
	if ($("ac_pwm_a") != null) {
		//AMBIENT CANVAS
		setTogglePosition("ac_pwm_a", controls.ambient_canvas.ac_pwm_a);
	}
	//PRESET
	//check for a difference before setting preset state
	if (existingControls.preset != controls.preset) {
		setActivePreset(controls.preset, panel + "_preset_buttons", pulsate)
	}
	//update global controls hash
	window.controls = recursive_clone(controls);
}