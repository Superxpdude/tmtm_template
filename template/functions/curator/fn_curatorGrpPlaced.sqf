/*
	XPT_fnc_curatorGrpPlaced
	Author: Superxpdude
	Adds a all units within a curator placed group as editable units to all other curators.
	
	Parameters:
		0: Object - Curator module that placed the group
		1: Object - Group placed by the curator
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
params [
	["_curator", nil, [objNull]],
	["_placed", nil, [grpNull]]
];

// Error checking
if ((isNil "_curator") OR (isNil "_placed")) exitWith {
	[2, "Curator or placed unit undefined", 0] call XPT_fnc_log;
};

// Loop through all available curators
{
	// Add all units in the placed group as editable objects
	_x addCuratorEditableObjects [(units _placed), true];
} forEach (allCurators - [_curator]);

// Return nothing
nil;
