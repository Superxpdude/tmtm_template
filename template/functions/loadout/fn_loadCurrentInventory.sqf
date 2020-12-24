/*
	XPT_fnc_loadCurrentInventory
	Author: Superxpdude
	Loads the current inventory for the player unit (based on their classname and the current mission stage)
	
	Parameters:
		0: Object - Unit that needs a new loadout applied
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define our variables
params ["_unit"];
private ["_loadout"];

// Make sure the unit isn't a virtual entity
if (_unit isKindOf "VirtualMan_F") exitWith {};

// Check if the unit has a special loadout defined
_loadout = _unit getVariable ["loadout", nil];

// If no loadout is defined, grab the unit's classname as their loadout
if (isNil "_loadout") then {
	_loadout = typeOf _unit;
};


// Determine the version of loadout that's being used. Run the matching inventory script.
private _fn_checkInventoryVersion = {
	private _subClasses = "true" configClasses (_this select 1);
	private _class = if ((count _subClasses) > 0) then {selectRandom _subClasses} else {_this select 1};
	if (isNil {((_class) >> "weapons") call BIS_fnc_getCfgData}) then {
		_this call XPT_fnc_loadInventory;
	} else {
		_this call XPT_fnc_loadInventoryLegacy;
	};
};

/*
_subclasses = "true" configClasses _baseClass;
if ((count _subclasses) > 0) then {
	// If we have any subclasses, select a random one.
	_class = selectRandom _subclasses;
	_isSubclass = true;
} else {
	_class = _baseClass;
};
*/
// Find the correct loadout for the unit. Report an error if no loadout is found
switch true do {
	case (isClass ((getMissionConfig "CfgXPT") >> "stages" >> XPT_stage_active >> "loadouts" >> _loadout)): {
		[_unit, (getMissionConfig "CfgXPT") >> "stages" >> XPT_stage_active >> "loadouts" >> _loadout] call _fn_checkInventoryVersion;
	};
	// Keep the old loadouts location in here for legacy reasons
	case (isClass ((getMissionConfig "CfgXPT") >> "loadouts" >> _loadout)): {
		[_unit, (getMissionConfig "CfgXPT") >> "loadouts" >> _loadout] call _fn_checkInventoryVersion;
	};
	case (isClass ((getMissionConfig "CfgRespawnInventory") >> _loadout)): {
		[_unit, (getMissionConfig "CfgRespawnInventory") >> _loadout] call BIS_fnc_loadInventory;
	};
	// If no loadout is found, report an error
	default {
		[1, format ["No loadout defined for unit. Loadout: '%1' Unit: '%2'", _loadout, name _unit], 2] call XPT_fnc_log;
	};
};