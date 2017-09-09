/*
	XPT_fnc_stageInit
	Author: Superxpdude
	Initialises the mission "Stage" system. Called automatically in preInit
	
	Parameters:
		None
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Initialize stage variables
// Set "stage1" to be the active stage upon mission start
XPT_stage_active = "stage1";