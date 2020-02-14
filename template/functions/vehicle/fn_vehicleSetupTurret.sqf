/*
	XPT_fnc_vehicleSetupTurret
	Author: Superxpdude
	Called from XPT_fnc_vehicleSetup.
	To be executed where the turret is local.
	
	Parameters:
		0: Object - Vehicle to configure
		1: Array - Turret array to configure.
		
	Returns: Bool
		True if the turret was configured correctly
		False if there was an error configuring the turret
*/

#include "script_macros.hpp"

params [
	["_vehicle", nil, [objNull]],
	["_turretConfig", [], [[]]]
];

_turretConfig params [
	["_turretPath", nil, [[]]],
	["_turretWeapons", [], [[]]],
	["_turretMagazines", [], [[]]],
	["_turretLock", 0, [0]]
];

// Don't run if we have undefined variables
if (isNil "_vehicle") exitWith {
	[2,"XPT_fnc_vehicleSetupTurret called with undefined vehicle."] call XPT_fnc_log;
};
if (isNil "_turretPath") exitWith {
	[2,"XPT_fnc_vehicleSetupTurret called with undefined turret path."] call XPT_fnc_log;
};

// Only run if the turret is local to this machine
if !(_vehicle turretLocal _turretPath) exitWith {
	[2,"XPT_fnc_vehicleSetupTurret executed where turret is not local."] call XPT_fnc_log;
};

// Start with magazines first, this way any new weapons will be automatically loaded.
if ((count _turretMagazines) > 0) then {
	// If any magazines have been defined, remove all existing magazines
	{
		_vehicle removeMagazineTurret [_x,_turretPath];
	} forEach (_vehicle magazinesTurret _turretPath);
	
	// Add the new turret magazines
	{
		private ["_magazine"];
		_magazine = (_x select 0);
		for "_i" from 1 to (_x select 1) do {
			_vehicle addMagazineTurret [_magazine, _turretPath];
		};
	} forEach _turretMagazines;
};

// Next replace the turret weapons
if ((count _turretWeapons) > 0) then {
	// If any weapons have been defined, remove all existing weapons
	{
		_vehicle removeWeaponTurret [_x,_turretPath];
	} forEach (_vehicle weaponsTurret _turretPath);
	
	// Add the new turret weapons
	{
		_vehicle addWeaponTurret [_x,_turretPath];
	} forEach _turretWeapons;
};

// Set the lock status of the turret
// Convert the number to a boolean
switch (_x select 3) do {
	case 0: {_x set [3, false]};
	case 1: {_x set [3, true]};
	default {_x set [3, nil]}; // Set the value to nil if it's not a 1 or 0
};
// If the desired lock status is defined, set it.
if (!isNil {_x select 3}) then {
	_vehicle lockTurret [_turretPath, _x select 3];
};