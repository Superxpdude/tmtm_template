/*
	XPT_fnc_initPlayerServer
	Author: Superxpdude
	Handles template specific entries in initPlayerServer
	
	Parameters:
		Designed to be called directly from initPlayerServer.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
params ["_player", "_jip"];

// Call the headless client connect function
if ((["headlessClient", 0] call BIS_fnc_getParamValue) == 1) then {
	_this call XPT_fnc_headlessConnect;
};