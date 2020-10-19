/*
	XPT_fnc_curatorAssignUnit
	Author: Superxpdude
	Assigns a player to a curator unit.
	Designed to be remoteExec'd from the client.
	
	Parameters:
		0: Object - Player unit to be assigned to a curator
		1: Object - Curator unit to assign the player to
		OR
		1: String - String name of the curator unit
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only to be run on the server
if (!isServer) exitWith {};

// Define variables
params [
	["_unit", nil, [objNull]],
	["_curator", nil, [objNull, ""]]
];

// Ensure that the unit and curator are defined
if (isNil "_unit") exitWith {
	[2, "Function called with no unit defined", 0] call XPT_fnc_log;
};
if (isNil "_curator") exitWith {
	[2, "Function called with no curator defined", 0] call XPT_fnc_log;
};

_assignCurator = {
	params ["_unit", "_curatorModule"];
	unAssignCurator _curatorModule;
	sleep 1;
	_unit assignCurator _curatorModule;
	{
		_x removeCuratorEditableObjects [[_unit],false];
	} forEach allCurators;
	[] remoteExec ["openCuratorInterface", _unit];
};

// If the curator is a string, grab the object
if ((typeName _curator) == "STRING") then {
	if !(call compile format ["%1 in allCurators", _curator]) exitWith {
		[1, format ["Invalid curator string provided: (%1)", _curator], 2] call XPT_fnc_log;
	};
	_curatorModule = (call compile format ["%1", _curator]);
	[_unit, _curatorModule] spawn _assignCurator;
} else {
	_curatorModule = _curator;
	[_unit, _curatorModule] spawn _assignCurator;
};