/*
	XPT_fnc_debugCuratorFix
	Author: Superxpdude
	Fixes a black-screen bug that can sometimes occur with the zeus interface
	
	Parameters:
		0: Object - Player unit
		1: Object - Curator module
		
	Returns: Nothing
*/

// Only works if run on the server
if (!isServer) exitWith {_this remoteExec ["XPT_fnc_debugCuratorFix", 2];};

// Define variables
params ["_unit", "_curator"];

// Fix the curator black screen by unassigning the unit, and reassigning it to the curator module
unassignCurator _curator;
// Wait three seconds
sleep 3;
// Reassign the unit to the curator
_unit assignCurator _curator;