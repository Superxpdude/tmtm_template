/*
	XPT_fnc_onPlayerKilled
	Author: Superxpdude
	Handles template specific entries in onPlayerKilled
	
	Parameters:
		Designed to be called directly from onPlayerKilled.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define parameters
_this params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Disable feedback post-processing effects when dead.
BIS_fnc_feedback_allowPP = false;

// Save the player's radio channels
if ((getMissionConfigValue "XPT_acre_enable") == 1) then {
	[_oldUnit] call XPT_fnc_radioHandleDeath;
};