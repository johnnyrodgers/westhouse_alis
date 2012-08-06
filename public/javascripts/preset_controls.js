function initializePresetControls() {
	document.observe("dom:loaded", function() {
		//iterate over array and evaluate each function statement (allows arguments to be stored in function calls)
		window.loadFunctions.each(function(func) {
			eval(func);
		});
	});
}

function presetSliderCallback(object) {
	//assign element id to variable and strip "_handle" suffix
	var element = object.element.id.replace("_handle", "");	
	$(element + '_mirror').hide();
	//assign attributes to variables (stored as strings in HTML attributes)
	subsystem = object.element.getAttribute("subsystem");
	master = object.element.getAttribute("master");
	slave = object.element.getAttribute("slave");
	//set positions and values for masters and slaves
	if (master == "true") {
		$(element + '_master_status').hide();
		eval(element + '_slaves').each(function(e) {
			$(e + '_master_status').hide();
			setSliderPosition(e, $("preset_" + element).value, false, false);
			$('preset_' + e).value = $("preset_" + element).value;
		});
	}
	if (slave == "true") {
		eval(element + '_masters').each(function(e) {
			if ($("preset_" + e).value != $("preset_" + element).value) {
				showMasterStatus(e);
			}				
		});			
	}
}