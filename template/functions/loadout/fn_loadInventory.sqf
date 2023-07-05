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
if (isNil "_unit") exitWith {
	["error", "Function called with no unit defined", 0] call XPT_fnc_log;
	false;
};

if (isNil "_baseClass") exitWith {
	["error", "Function called with no base class defined", 0] call XPT_fnc_log;
	false;
};

// Resolve loadout array, by default XPT_fnc_resolveInventory will be used
private _getLoadoutFunctionName = getMissionConfigValue ["XPT_customLoadouts_loadoutOverrideFunction", "XPT_getLoadoutArray"];
private _fnc_getLoadout = missionNamespace getVariable [_getLoadoutFunctionName, scriptNull];

// Provided function does not exist
if (isNull _fnc_getLoadout) then { 
	["error", format["Provided getLoadoutArray function [%1] does not exist!", _getLoadoutFunctionName], 0] call XPT_fnc_log;
	false;
};

// Ensure that we've received what looks like loadout array
private _loadout = [_unit, _baseClass] call _fnc_getLoadout;

if ((isNil "_loadout") OR (typeName _loadout != "ARRAY")) exitWith {
	["error", format["Received unexpected loadout type from [%1] call!", _getLoadoutFunctionName], 0] call XPT_fnc_log;
	false;
};
if (count(_loadout) < 10) exitWith {
	["error", format["Received malformed loadout array from [%1] call!", _getLoadoutFunctionName], 0] call XPT_fnc_log;
	false;
};

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