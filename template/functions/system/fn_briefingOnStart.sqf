/*
	XPT_fnc_briefingOnStart
	Author: Superxpdude
	Automatically creates briefings on mission start
	
	Parameters:
		Designed to be called in postInit
		
	Returns: Nothing
*/

// Only run on a machine with a player
if (!hasInterface) exitWith {};

// Define variabls
private ["_briefings", "_sideNum", "_sides"];

// Grab a list of briefing configs with the onStart flag
_briefings = "getNumber (_x >> 'onStart') == 1" configClasses ((getMissionConfig "CfgXPT") >> "briefings");

// Create the briefings
_briefings call XPT_fnc_briefingCreate;