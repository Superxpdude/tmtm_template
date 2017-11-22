/*
	XPT_fnc_initPlayerLocal
	Author: Superxpdude
	Handles template specific entries in initPlayerLocal
	
	Parameters:
		Designed to be called directly from initPlayerLocal.sqf
		
	Returns: Nothing
*/

// Define variables
params ["_player", "_jip"];

// Include template version information
#include "..\..\version.hpp"

// Initialise the curator menu (if the player is a curator)
[] spawn XPT_fnc_curatorMenu;

// Initialise the client-side part of dynamic groups
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

// Create template-specific briefing sections
player createDiarySubject ["XPT_template", "XP Template"];
// Add a version readout to the briefing section
player createDiaryRecord ["XPT_template", ["Version",
	"This mission is using version " + __XPTVERSION__ + " of the XP template."
]];

// Display the debug mode warning (if debug mode is enabled)
if (["XPT_debugMode", 0] call BIS_fnc_getParamValue) then {
	["XPT_debugMode"] call BIS_fnc_showNotification;
};
