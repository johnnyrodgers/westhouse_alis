// accepts a client_id from each registered client (browser) and assigns that client_id to the global scope
function initializeControls(client_id) {
	//assign client_id to window scope
	window.client_id = client_id;
	//prevent text selection
	document.onselectstart = function() { return false; } // ie
  document.onmousedown = function() { return false; } // mozilla
	//this should also get the current control state from an active client and set it in the new client, to avoid the new client's settings overriding the actual state	
  //call functions in loadFunctions array on dom:loaded event
  document.observe("dom:loaded", function() {
		//iterate over array and evaluate each function statement (allows arguments to be stored in function calls)
		window.loadFunctions.each(function(func) {
			eval(func);
		});
	});
}

//updates the window.controls hash with a new value for a specific control 
function setControlValue(subsystem, key, value) {
	console.log("setting control value: " + subsystem + ", " + key + ", " + value);
	window.controls[subsystem][key] = value;
}

//push() either submits the passed javascript or the window.controls hash (encoded as JSON) to the push server via an AJAX request
function push(javascript) {
	//push the javascript argument to be rendered on other clients
	if (javascript) {
		new Ajax.Request("/controls/push", { 
			method: "get", 
			parameters: { 
				"javascript": javascript,
				"client_id": window.client_id
			}
		});	
	}
	//push the entire controls hash to be updated on other clients
	else {
		new Ajax.Request("/controls/push", { 
			method: "get", 
			parameters: { 
				"controls": Object.toJSON(window.controls),
				"client_id": window.client_id
			}
		});
	}
}

//sendCommand accepts a device_id (int) and a command (string) to send to the sendCommand method of the Controls controller
function sendCommand(device_id, command) {
	new Ajax.Request("/controls/sendCommand", { 
		method: "get", 
		parameters: { 
			"device_id": device_id,
			"command": command,
		}
	});	
}

//pushSlider() accepts a draggable object and pushes its state to other clients
function pushSlider(object) {
	//assign element id to variable and strip "_handle" suffix
	var element = object.element.id.replace("_handle", "");	
	$(element + '_mirror').hide();
	//assign attributes to variables (stored as strings in HTML attributes)
	master = object.element.getAttribute("master");
	slave = object.element.getAttribute("slave");
	device_id = object.element.getAttribute("device_id");
	command = object.element.getAttribute("command");
	subsystem = object.element.getAttribute("subsystem");
	//send command
	if (subsystem == "lights") {
		//assign new value to variable
		new_value = $(element + "_value").innerHTML;
		if (new_value == 'ON') { new_value = 100; }
		else if (new_value == 'OFF') { new_value = 0; }
		else { new_value = parseInt(new_value); }
		//send command, accounting for ON/OFF		
		if (new_value == 0) {
			sendCommand(device_id, 'OFF');
		}
		else {
			sendCommand(device_id, 'ON ' + new_value);
		}
		//set control value - has to happen after the above since we need a delta value
    setControlValue('lights', element, new_value);	    
	}
	//set positions and values for masters and slaves
	if (master == "true") {
		$(element + '_master_status').hide();
		eval(element + '_slaves').each(function(e) {
			$(e + '_master_status').hide();
			setSliderPosition(e, new_value, false, false);
			setControlValue(subsystem, e, new_value);	
		});
	}
	if (slave == "true") {
		eval(element + '_masters').each(function(e) {
			if (window.controls[subsystem][e] != window.controls[subsystem][element]) {
				showMasterStatus(e);
			}				
		});			
	}
	//if the slider is a master, push out all controls, otherwise just push the individual control
	if (master == "true") {
		push();
	}
	else {
		//push javascript to clients
		new_value = window.controls[subsystem][element];
		//correct for ON/OFF and UP/DOWN
		if (new_value == "ON") { new_value = 100; }
		else if (new_value == "OFF") { new_value = 0; }
		push('setSliderPosition("' + element + '", ' + new_value + '); setControlValue("' + subsystem + '", "' + element + '", ' + new_value + ');');	
	}
}

//pushToggle() accepts a draggable object with snapping and pushes its state to other clients
function pushToggle(object) {
	//assign element id to variable and strip "_handle" suffix
	var element = object.element.id.replace("_handle", "");	
	//assign attributes to variables (stored as strings in HTML attributes)
	device_id = object.element.getAttribute("device_id");
	//assign state to variable
	state = window.controls.lights[element];
	//send commands
	if (state == 'ON' || state == 1) {
		if (element.indexOf("ac_pwm") != -1) {		    		
			new Ajax.Request('/controls/switchAmbientCanvas', { 
				method: 'get', 
				parameters: { 
					'command': 'ON',
				}
			});
		}
		else {
			sendCommand(device_id, 'ON');	
		}		    	
	}
	else if (state == 'OFF' || state == 0) {
		if (element.indexOf("ac_pwm") != -1) {
			new Ajax.Request('/controls/switchAmbientCanvas', { 
				method: 'get', 
				parameters: { 
					'command': 'OFF',
				}
			});
		}
		else {
	  		sendCommand(device_id, 'OFF');	
		}		    	
	}
	//push javascript to clients
  push('setTogglePosition("' + element + '", "' + state + '"); setControlValue("lights", "' + element + '", "' + state + '");');
}

function pushTemperature(control_id, newTemp) {
	//set control value
	setControlValue('hvac', control_id, newTemp); 	
	//push value
	push('setTemperature("' + control_id + '", ' + newTemp + '); setControlValue("hvac", "' + control_id + '", "' + newTemp + '");');
}