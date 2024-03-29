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
_this call XPT_fnc_headlessConnect;