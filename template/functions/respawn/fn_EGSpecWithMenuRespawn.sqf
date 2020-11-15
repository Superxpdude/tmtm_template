/*
	XPT_fnc_EGSpecWithMenuRespawn
	Author: blah2355
	Handles entering and leaving End Game spectator mode with MenuPosition respawn template active
	
	Parameters: None
	
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define parameters
params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Sleep delay time for EG spectator, finishes roughly 5 seconds of respawnDelay
private _terminateEGSpecDelay = _respawnDelay - 10;

// Wait for Menu Respawn screen to appear and close it immediately
waitUntil{missionNameSpace getVariable "BIS_RscRespawnControlsMap_shown"};
["close"] call BIS_fnc_showRespawnMenu;

[
	"Initialize",
	[
		_oldUnit, 	// spectator target (player)
		[],			// whitlisted sides
		false,		// allow viewing AI
		true,		// allow free camera
		true,		// allow 3rd person camera
		true,		// show focus info stat widget
		true,		// show camera buttons widget
		true,		// show controls helper widget
		true,		// show header widget
		true		// show entity/location list
	]
] call BIS_fnc_EGSpectator;

sleep _terminateEGSpecDelay;
["Terminate", [_oldUnit]] call BIS_fnc_EGSpectator;
["open"] call BIS_fnc_showRespawnMenu;