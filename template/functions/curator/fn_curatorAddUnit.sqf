/*
	XPT_fnc_curatorAddUnit
	Author: Superxpdude
	Adds an object as an editable unit for all curators in the mission.
	Primarily used to add player units to zeus when they spawn in.
	Will automatically add all crew of a vehicle if not otherwise defined.
	
	Parameters:
		0: Object - Unit to be added to curators
		1: Boolean (Optional) - False to prevent vehicle crew from being added as editable
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Define variables
params [
	["_unit", objNull, [objNull]],
	["_addCrew", true, [true]]
]

// Add unit to all curators
{
	_x addCuratorEditableObjects [_unit, _addCrew];
} forEach allCurators;

// Return nothing
nil
