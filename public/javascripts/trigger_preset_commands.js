//send commands to all devices based on preset
function triggerPresetCommands(controls) {
/*
	console.log(controls);
	console.log(devices);
*/
	//LIGHTS
	for (var light in controls.lights) {
		// DIMMERS
		if (light.indexOf("dimmer") != -1) {
			if (controls.lights[light] == 0) {
				sendCommand(devices[light], 'OFF');
			}
			else {
				sendCommand(devices[light], 'ON ' + controls.lights[light]);
			}
		}
		// TOGGLES
		else {
			if (controls.lights[light] == 0) {
				sendCommand(devices[light], 'OFF');
			}
			else {
				sendCommand(devices[light], 'ON');
			}
		}
	}
	//AMBIENT CANVAS
	if (controls.ambient_canvas.ac_pwm_a == 1) { ac_state = "ON"; }
	else { ac_state = "OFF"; }
	new Ajax.Request('/controls/switchAmbientCanvas', { 
		method: 'get', 
		parameters: { 
			'command': ac_state,
		}
	});
}