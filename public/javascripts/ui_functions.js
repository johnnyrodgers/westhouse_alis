/* JAVASCRIPT UI FUNCTIONS - West House Controls - Johnny Rodgers */

//PRESETS
// accepts a preset id and makes it active
function setPreset(preset_id, set_id, panel) {
	setActivePreset(preset_id, set_id);
	//send commands
	triggerPresetCommands(eval("preset_" + preset_id + "_settings"));
	//update controls (locally)
	updateControls(eval("preset_" + preset_id + "_settings"), true, false, panel);
	//push updates to other panels
	push();
}

function setActivePreset(preset_id, set_id, pulsate) {
	//set control value
	$(set_id).select(".button").each(function(button) {
		$(button).removeClassName("button_active");
	});
	$(set_id + "_" + preset_id).addClassName("button_active");
	//set pulsate default value (true)
	var pulsate = (typeof pulsate == 'undefined') ? true : pulsate;
	//pulsate
	if (pulsate) { $(set_id + "_" + preset_id).pulsate({ pulses: 12, duration: 15, from: 0.4 }); }
}

//SLIDERS
function setSliderPosition(slider_id, value) {
	//calculate element height by taking the slider height and subtracting padding and handle height
	var elementHeight = parseInt($(slider_id).getStyle('height')) - parseInt($(slider_id + '_handle').getStyle('height'));
	//calculate amount to offset from top by taking the element height and dividing it by the value as a percentage
	var topValue = elementHeight - (elementHeight / (100 / value));
	//set offset
	$(slider_id + '_handle').setStyle({ top: topValue + 'px' });
	//get subsystem
	subsystem = $(slider_id + '_handle').getAttribute("subsystem");
	//correct for ON/OFF and UP/DOWN
	if (value == 100) { value = "ON"; }
	else if (value == 0) { value = "OFF"; }
	else { value = value + '%'; }
	//update value
	$(slider_id + '_value').update(value);
}

function showMasterStatus(slider_id) {
	$(slider_id + "_master_status").show();
}

//TOGGLES
function setTogglePosition(toggle_id, state) {
	if (state == 'OFF' || state == 0) { state = "OFF"; }
	else { state = "ON"; }
	//calculate element height by taking the toggle height and subtracting padding and handle height
	var elementHeight = parseInt($(toggle_id).getStyle('height')) - (parseInt($(toggle_id + '_handle').getStyle('height') / 2));
	//calculate amount to offset from top
	var topValue = 0; // ON
	if (state == "OFF") { var topValue = 108; }
	//set offset	
	$(toggle_id + '_handle').setStyle({ top: topValue + 'px' });
	//update value
	$(toggle_id + '_value').update(state);
}

//THERMOSTATS
function setTemperature(control_id, newTemp, pulsate) {
	//set status according to direction
	if (newTemp > window.controls.hvac.temperature) { $(control_id + '_status').update('now heating'); }
	else if (newTemp < window.controls.hvac.temperature) { $(control_id + '_status').update('now cooling'); }
	//add decimal place to temp if it is an integer
	if (newTemp.toString().indexOf(".") == -1) {
		newTemp = newTemp.toString() + ".0";
	}
	//update label
	$(control_id + "_value").update(newTemp);
	//set pulsate default value (true)
	var pulsate = (typeof pulsate == 'undefined') ? true : pulsate;
	//pulsate
//	if (pulsate) { $(control_id + '_value_and_units').pulsate({ pulses: 4, duration: 5, from: 0.4 }); }
}