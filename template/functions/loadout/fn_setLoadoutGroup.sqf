/*
	XPT_fnc_setLoadoutGroup
	Author: Superxpdude
	Handles setting a "loadout group" for use in the mission.
	Must be run on the server
	
	Parameters:
		0: String - Name of new loadoutGroup to use
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only run on the server
if (!isServer) exitWith {};

params [
	["_loadoutGroup", "defaultGroup", [""]]
];

// Set the new loadout group
missionNamespace setVariable ["XPT_loadout_activeGroup",_loadoutGroup,true];