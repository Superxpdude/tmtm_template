/*
	XPT_fnc_radioHandleRespawn
	Author: Superxpdude
	Handles assigning radios when a player respawns.
	Accounts for any changes a player may have made to their radio settings while they were previously alive.
	
	Parameters:
		0: Object - Unit that respawned. Defaults to player if undefined.
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Wait until the mission has started
waitUntil {time > 0};

// Exit if the function is run on a machine that does not have a player
if (!hasInterface) exitWith {};

// Define variables
_unit = _this param [0, player, [objNull]];
// Don't run on Zeus units
if (_unit isKindOf "VirtualMan_F") exitWith {};

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

// Assign settings to the LR radios
// Spawn this as well
[_unit] spawn {
	private _unit = _this select 0;
	
	// Check if the player has an LR radio
	private _backpackRadio = _unit call TFAR_fnc_backpackLR;
	if (isNil "_backpackRadio") exitWith {};
	// Wait until the player's LR radio has been assigned, and the server has finished setting up radios.
	waitUntil {(call TFAR_fnc_haveLRRadio) and !(isNil "XPT_radio_setup_complete")};
	
	// Check if any previous settings have been saved
	// Settings are stored in an array that contains the classname of the radio, as well as a saved copy of TFAR_fnc_getLrSettings.
	private _lrSettings = _unit getVariable ["XPT_savedLRSettings", nil];
	// Get the current LR radio
	private _lrRadio = (backpack _unit);
	// Grab the classname of the old radio
	private _oldRadio = if (isNil "_lrSettings") then {"none"} else {_lrSettings select 0};
	// Grab the side of the new radio. (The encryption code allows us to determine what side the radio belongs to).
	private _radioSide = (configfile >> "CfgVehicles" >> _lrRadio >> "tf_encryptionCode") call BIS_fnc_getCfgData;

	// If any LR settings have been defined, assign them to the player's radio
	// Only do so if the encryption codes match between the radios
	if ((!isNil "_lrSettings") AND (_oldRadio == _lrRadio)) then {
		[_backpackRadio, (_lrSettings select 1)] call TFAR_fnc_setLRSettings;
	} else {
		// If the unit has an LR channel defined in the editor, set it here
		private _lrChannel = _unit getVariable ["XPT_TFAR_LRChannel", (group _unit) getVariable [
			"XPT_TFAR_LRChannel", _unit getVariable ["TFAR_LRChannel", (group _unit) getVariable ["TFAR_LRChannel", nil]]]];
		if (!isNil "_lrChannel") then {
			[_backpackRadio, _lrChannel] call TFAR_fnc_setLrChannel;
		};
	};
};