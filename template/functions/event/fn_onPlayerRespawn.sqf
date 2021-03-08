/*
	XPT_fnc_onPlayerRespawn
	Author: Superxpdude
	Handles template specific entries in onPlayerRespawn
	
	Parameters:
		Designed to be called directly from onPlayerRespawn.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define parameters
params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Re-enable feedback post-processing effects upon respawn
BIS_fnc_feedback_allowPP = true;

// Check if the player needs a loadout assigned
if ((getMissionConfigValue ["XPT_customLoadouts",0]) == 1) then {
	[_newUnit] call XPT_fnc_loadCurrentInventory;
};

// Make sure the new player unit is editable by all curators. Needs to be run on the server.
[_newUnit] remoteExec ["XPT_fnc_curatorAddUnit", 2];

// Sets the insignia of the unit to the TMTM insignia
if ((getMissionConfigValue ["XPT_tmtm_insignia",1]) == 1) then {
	[_newUnit, "tmtm_patch"] call BIS_fnc_setUnitInsignia;
};

// Load the player's radio settings. (This needs to happen after the inventory is loaded)
if ((getMissionConfigValue ["XPT_radio_enable",1]) == 1) then {
	_this spawn XPT_fnc_radioHandleRespawn;
};