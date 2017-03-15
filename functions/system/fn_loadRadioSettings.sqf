// fn_loadRadioSettings.sqf
// Handles copying radio settings from the player's old radios to their new radios upon respawn

// Copy the SW radio settings
// Check if the player has a new SW radio, and an old SW radio
if (([] call TFAR_fnc_haveSwRadio) && (!isNil (missionNamespace getVariable [format ["%1_SW", getPlayerUID player], nil]))) then {
	// Wait until the player has their SW radio replaced with a unique radio
	waitUntil {
		// Only check once per second. TFAR can be slow sometimes
		sleep 1;
		!(([] call TFAR_activeSwRadio) call TFAR_fnc_isPrototypeRadio)
	};
	// Copy the settings to the new radio
	[missionNamespace getVariable [format ["%1_SW", getPlayerUID player], nil], [] call TFAR_activeSwRadio] call TFAR_fnc_copySettings;
};

// Copy the LR radio settings
// Check if the player has a new LR radio, and an old LR radio
if (([] call TFAR_fnc_haveLrRadio) && (!isNil (missionNamespace getVariable [format ["%1_LR", getPlayerUID player], nil]))) then {
	// We don't have to wait for the unique radio, because LR radios are stored differently
	// Copy the settings to the new radio
	[missionNamespace getVariable [format ["%1_LR", getPlayerUID player], nil], [] call TFAR_activeLrRadio] call TFAR_fnc_copySettings;
};