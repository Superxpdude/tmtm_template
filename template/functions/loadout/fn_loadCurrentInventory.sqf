/*
	XPT_fnc_loadCurrentInventory
	Author: Superxpdude
	Loads the current inventory for the player unit (based on their classname and the current mission stage)
	
	Parameters:
		0: Object - Unit that needs a new loadout applied
		
	Returns: Nothing
*/

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

// Find the correct loadout for the unit. Report an error if no loadout is found
switch true do {
	case (isClass ((getMissionConfig "CfgXPT") >> XPT_stage_active >> "loadouts" >> _loadout)): {
		[_unit, (getMissionConfig "CfgXPT") >> XPT_stage_active >> "loadouts" >> _loadout] call XPT_fnc_loadInventory;
	};
	// Keep the old loadouts location in here for legacy reasons
	case (isClass ((getMissionConfig "CfgXPT") >> "loadouts" >> _loadout)): {
		[_unit, (getMissionConfig "CfgXPT") >> "loadouts" >> _loadout] call XPT_fnc_loadInventory;
	};
	case (isClass ((getMissionConfig "CfgRespawnInventory") >> _loadout)): {
		[_unit, (getMissionConfig "CfgRespawnInventory") >> _loadout] call BIS_fnc_loadInventory;
	};
	default {
		[[false, format ["[XPT-LOADOUT] Missing Loadout. Unit: ""%1"", Loadout: ""%2""", typeOf _unit, _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
	};
};