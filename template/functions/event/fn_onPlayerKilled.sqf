/*
	XPT_fnc_onPlayerKilled
	Author: Superxpdude
	Handles template specific entries in onPlayerKilled
	
	Parameters:
		Designed to be called directly from onPlayerKilled.sqf
		
	Returns: Nothing
*/

// Define parameters
_this params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Disable feedback post-processing effects when dead.
BIS_fnc_feedback_allowPP = false;

// Save the player's radio settings
//_this call XPT_fnc_radioHandleDeath;