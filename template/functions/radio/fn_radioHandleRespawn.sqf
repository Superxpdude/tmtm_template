/*
	XPT_fnc_radioHandleRespawn
	Author: Superxpdude
	Handles assigning radio settings when a player respawns.
	Accounts for any changes a player may have made to their radio settings while they were previously alive.
	
	Parameters:
		0: Object - Unit that respawned. Defaults to player if undefined.
		
	Returns: Nothing
*/

// Exit if the function is run on a machine that does not have a player
if (!hasInterface) exitWith {};

// Define variables
_unit = _this param [0, player, [objNull]];

// If the unit is not local, run this function where it is local.
if (!local _unit) exitWith {
	// If this has not been run on the server, we need to send it to the server to find the right owner
	if (!isServer) then {
		// Send the script on the server
		[_unit] remoteExec ["XPT_fnc_radioHandleRespawn", 2];
	} else {
		// If this has been run on the server, find out who the owner is (since we've already confirmed it isn't local)
		[_unit] remoteExec ["XPT_fnc_radioHandleRespawn", owner _unit];
	};
};

// Assign settings to the SW radios
// We need to spawn this so that it waits until the radios have been assigned without stopping the LR radio portion
[_unit] spawn {
	// Mark down the time that the script was spawned
	private _unit = _this select 0;
	_startTime = time;
	// Wait until the player's radios have been assigned, or the timeout has been reached
	waitUntil {((call TFAR_fnc_haveSWRadio) OR ((_startTime + 30) > time))};
	// If the player does not have a radio (because the timeout was reached), exit the script.
	if !(call TFAR_fnc_haveSWRadio) exitWith {};
	
	// Check if any previous settings have been saved
	private _srSettings = _unit getVariable ["XPT_savedSRSettings", nil];
	// Grab the classname of the new radio
	private _srRadio = call TFAR_fnc_activeSwRadio;
	// Grab the encryption code of the old radio
	private _oldCode = if (isNil "_srSettings") then {"none"} else {_srSettings select 4};
	// Grab the encryption code of the new radio
	private _newCode = (configFile >> "CfgWeapons" >> _srRadio >> "tf_encryptionCode") call BIS_fnc_getCfgData;

	// If any SR settings have been defined, assign them to the player's radio
	// Only do so if the encryption codes match between the radios
	if ((!isNil "_srSettings") AND (_oldCode == _newCode)) then {
		[call TFAR_fnc_activeSwRadio, _srSettings] call TFAR_fnc_setSwSettings;
	} else {
		// If we have no saved data, or the encryption codes don't match, generate default values
		private _srSettings = [false] call TFAR_fnc_generateSrSettings;
		// Set the radio frequencies
		switch (_newCode) do {
			case "tf_west_radio_code" do {_srSettings set [2,TFAR_defaultFrequencies_sr_west];};
			case "tf_east_radio_code" do {_srSettings set [2,TFAR_defaultFrequencies_sr_east];};
			case "tf_guer_radio_code" do {_srSettings set [2,TFAR_defaultFrequencies_sr_independent];};
		};
		// Set the default channel. Grab the value from the player unit first, otherwise try the group. If both don't exist, use the default (channel 0).
		_srSettings set [0, (_unit getVariable ["TFAR_SRChannel", ((group _unit) getVariable ["TFAR_SRChannel", 0])])];
		// Assign the radio settings
		[call TFAR_fnc_activeSwRadio, _srSettings] call TFAR_fnc_setSwSettings;
	};
};



// Assign settings to the LR radios
// Spawn this as well
[_unit] spawn {
	// Mark down the time that the script was spawned
	private _unit = _this select 0;
	_startTime = time;
	// Wait until the player's radios have been assigned, or the timeout has been reached
	waitUntil {((call TFAR_fnc_haveLRRadio) OR ((_startTime + 30) > time))};
	// If the player does not have a radio (because the timeout was reached), exit the script.
	if !(call TFAR_fnc_haveLRRadio) exitWith {};
	
	// Check if any previous settings have been saved
	private _lrSettings = _unit getVariable ["XPT_savedLRSettings", nil];
	// Get the current LR radio
	private _lrRadio = call TFAR_fnc_activeLRRadio;
	// Grab the encryption code of the old radio
	private _oldCode = if (isNil "_lrSettings") then {"none"} else {_lrSettings select 4};
	// Grab the encryption code of the new radio
	private _newCode = (configFile >> "CfgVehicles" >> (backpack _unit) >> "tf_encryptionCode") call BIS_fnc_getCfgData;

	// If any SR settings have been defined, assign them to the player's radio
	// Only do so if the encryption codes match between the radios
	if ((!isNil "_lrSettings") AND (_oldCode == _newCode)) then {
		[call TFAR_fnc_activeLRRadio, _lrSettings] call TFAR_fnc_setLRSettings;
	} else {
		// If we have no saved data, or the encryption codes don't match, generate default values
		private _lrSettings = [false] call TFAR_fnc_generateLrSettings;
		// Set the radio frequencies
		switch (_newCode) do {
			case "tf_west_radio_code" do {_lrSettings set [2,TFAR_defaultFrequencies_lr_west];};
			case "tf_east_radio_code" do {_lrSettings set [2,TFAR_defaultFrequencies_lr_east];};
			case "tf_guer_radio_code" do {_lrSettings set [2,TFAR_defaultFrequencies_lr_independent];};
		};
		// Set the default channel. Grab the value from the player unit first, otherwise try the group. If both don't exist, use the default (channel 0).
		_lrSettings set [0, (_unit getVariable ["TFAR_LRChannel", ((group _unit) getVariable ["TFAR_LRChannel", 0])])];
		// Assign the radio settings
		[call TFAR_fnc_activeLRRadio, _lrSettings] call TFAR_fnc_setLRSettings;
	};
};