/*
	XPT_fnc_curatorObjPlaced
	Author: Superxpdude
	Adds a curator placed object as an editable object to all other curators.
	
	Parameters:
		0: Object - Curator module that placed the object
		1: Object - object placed by the curator
		
	Returns: Nothing
*/

// Define variables
params [
	["_curator", nil, [objNull]],
	["_placed", nil, [objNull]]
];

// Error checking
if ((isNil "_curator") OR (isNil "_placed")) exitWith {
	[false, "Curator or placed unit undefined", 0] call XPT_fnc_error;
};

// Loop through all available curators
{
	// Add the placed object as an editable object
	_x addCuratorEditableObjects [[_placed], true];
} forEach (allCurators - [_curator]);

// Return nothing
nil;
