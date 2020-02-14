/*
	XPT_fnc_curatorAddUnit
	Author: Superxpdude
	Adds an object as an editable unit for all curators in the mission.
	Primarily used to add player units to zeus when they spawn in.
	Will automatically add all crew of a vehicle if not otherwise defined.
	
	Parameters:
		0: Object - Unit to be added to curators
		OR
		0: Array - Array of units to be added to curators
		1: Boolean (Optional) - False to prevent vehicle crew from being added as editable
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only to be run on the server
if (!isServer) exitWith {};

// Define variables
params [
	["_unit", nil, [objNull, []]],
	["_addCrew", true, [true]]
];

// If the unit is nil, exit the function
if (isNil "_unit") exitWith {
	[2, "Function called with no unit defined", 0] call XPT_fnc_log;
};

// If the unit is an object, convert it to an array
if (typeName _unit == "OBJECT") then {
	_unit = [_unit];
};

// Add unit to all curators
{
	_x addCuratorEditableObjects [_unit, _addCrew];
} forEach allCurators;

// Return nothing
nil
