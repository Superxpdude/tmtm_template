/*
	XPT_fnc_loadInventory
	Author: Superxpdude
	Loads a custom inventory for a unit from a config file or resolve function if one is provided in description.ext
	
	Parameters:
		0: Object - Unit to apply loadout
		1: Config - Loadout to apply.
		
	Returns: Bool
		True if loadout was applied successfully
		False if loadout was not applied successfully
*/

#include "script_macros.hpp"

// Define variables
private ["_subclasses", "_isSubclass", "_class"];
params [
	["_unit", nil, [objNull]],
	["_baseClass", nil, [configNull]]
];

// Exit the script if _unit is not an object or _class is not a config class
if ((isNil "_unit") or (isNil "_baseClass")) exitWith {false};

// setUnitLoadout is apparently a global command. This section is no longer needed
/*
if (!local _unit) exitWith {
	// If this has not been run on the server, we need to send it to the server to find the right owner
	if (!isServer) then {
		// Send the script on the server
		[_unit, _class] remoteExec ["XPT_fnc_loadInventory", 2];
	} else {
		// If this has been run on the server, find out who the owner is (since we've already confirmed it isn't local)
		[_unit, _class] remoteExec ["XPT_fnc_loadInventory", owner _unit];
	};
};
*/

// Resolve loadout array, by default XPT_fnc_resolveInventory will be used
// However, this can be overriden by the user by providing custom resolve function
private _loadout = [_unit, _baseClass] call XPT_customLoadouts_getLoadoutArrayFunction;

// Ensure that we've received loadout array
if (isNil "_loadout" || typeName _loadout != "ARRAY") exitWith {false};

// Should contain at least 10 entries for each loadout section
if (count(_loadout) < 10) exitWith {false};

// Apply the loadout
_unit setUnitLoadout _loadout;

// Check if the unit is overloaded
private _uniformLoad = loadUniform _unit;
private _vestLoad = loadVest _unit;
private _backpackLoad = loadBackpack _unit;

if (_uniformLoad > 1) then {
	["error", format ["Loadout [%1] has an overloaded uniform! Load: [%2]",configName _baseClass,_uniformLoad], "all"] call XPT_fnc_log;
};

if (_vestLoad > 1) then {
	["error", format ["Loadout [%1] has an overloaded vest! Load: [%2]",configName _baseClass,_vestLoad], "all"] call XPT_fnc_log;
};

if (_backpackLoad > 1) then {
	["error", format ["Loadout [%1] has an overloaded backpack! Load: [%2]",configName _baseClass,_backpackLoad], "all"] call XPT_fnc_log;
};

// Return true if script is completed.
true 