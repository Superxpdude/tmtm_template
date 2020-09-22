/*
	XPT_fnc_initPlayerLocal
	Author: Superxpdude
	Handles template specific entries in initPlayerLocal
	
	Parameters:
		Designed to be called directly from initPlayerLocal.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
params ["_player", "_jip"];

// Include template version information
#include "..\..\version.hpp"

// Initialise the curator menu (if the player is a curator)
[] spawn XPT_fnc_curatorMenu;

// Initialise the client-side part of dynamic groups
["InitializePlayer", [_player, true]] call BIS_fnc_dynamicGroups;

// Create template-specific briefing sections
_player createDiarySubject ["XPT_template", "XP Template"];
// Add a version readout to the briefing section
_player createDiaryRecord ["XPT_template", ["Version",
	"This mission is using version " + __XPTVERSION__ + " of the XP template."
]];

// This needs to be spawned so that it happens after the initialization is finished. Otherwise the notification doesn't work.
[] spawn {
	// Wait until the game has started before displaying the debug notification
	waitUntil {time > 2};
	// Display the debug mode warning (if debug mode is enabled)
	if ((["XPT_debugMode", 0] call BIS_fnc_getParamValue) == 1) then {
		["XPT_debugMode"] call BIS_fnc_showNotification;
	};
};

_zeus = _player getVariable ["XPT_zeusUnit", false];
if !(_zeus isEqualTo false) then {
	[1, format ["XPT_zeusUnit is deprecated. Unit: [%1] will not have Zeus access.",_newUnit], 2] call XPT_fnc_log;
};