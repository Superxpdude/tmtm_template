/*
	XPT_fnc_curatorLoadout
	Author: blah2355
	Sets custom loadouts to Zeus spawned units based on their classname
	
	Parameters:
		0: Object - Unit spawned by a curator
		
	Returns: Nothing
*/

#include "script_macros.hpp"

params [
	["_curator", nil, [objNull]],
	["_unit", nil, [objNull]]
];

// Exit if the unit is undefined
if (isNil "_unit") exitWith {
	[2, "Called with no unit defined", 0] call XPT_fnc_log;
};

private _fn_applyLoadout = {
	private _fn_unit = _this select 0;
	private _fn_loadout = _this select 1;
	if (isClass ((getMissionConfig "CfgXPT") >> "CuratorLoadouts" >> _fn_loadout)) then {
		[_fn_unit, (getMissionConfig "CfgXPT") >> "CuratorLoadouts" >> _fn_loadout] call XPT_fnc_loadInventory;
	};
};

// Get unit class name
if (_unit isKindOf "Man") then {
	_loadout = typeOf _unit;
	[_unit, _loadout] call _fn_applyLoadout;
} else {
	// If the unit is not a man, check if it has a crew
	if ((count (crew _unit)) > 0) then {
		// If the unit has a crew, run through them one by one
		{
			_loadout = typeOf _x;
			[_x, _loadout] call _fn_applyLoadout;
		} forEach (crew _unit);
	};
};