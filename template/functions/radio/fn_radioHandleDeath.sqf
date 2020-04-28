/*
	XPT_fnc_radioHandleDeath
	Author: Superxpdude
	Handles assigning radio channels when a player respawns.
	Only handles radio channels. Will not preserve other settings such as channel names, volume, or stereo settings.
	
	Parameters:
		Designed to be called directly from onPlayerKilled
		
	Returns: Nothing
*/
// Define variables

#include "script_macros.hpp"

_this params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Don't run on Zeus units
if (_oldUnit isKindOf "VirtualMan_F") exitWith {};

// Figure out if the player has radios
private _hasSR = _oldUnit call TFAR_fnc_activeSWRadio;
private _hasLR = _oldUnit call TFAR_fnc_backpackLR;

// If the player has an SR radio. Find the prototype classname and store it.
if (!isNil "_hasSR") then {
	// Grab the prototype classname of the unit's radio
	_srRadio = (configfile >> "CfgWeapons" >> _hasSR >> "tf_parent") call BIS_fnc_getCfgData;
	// Grab the settings of the unit's radio
	_srSettings = _hasSR call TFAR_fnc_getSWSettings;
	// Save the settings to the player
	player setVariable ["XPT_savedSRSettings", [_srRadio, _srSettings]];
};

// If the player has an LR radio. Store their radio settings
if (!isNil "_hasLR") then {
	// Grab the classname of the unit's backpack
	_lrRadio = (backpack _oldUnit);
	// Grab the settings of the unit's radio
	_lrSettings = _hasLR call TFAR_fnc_getLRSettings;
	// Save the settings to the player
	player setVariable ["XPT_savedLRSettings", [_lrRadio, _lrSettings]];
};