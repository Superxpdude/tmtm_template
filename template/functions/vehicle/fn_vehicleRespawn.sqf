/*
	XPT_fnc_vehicleRespawn
	Author: Superxpdude
	Handles restoring pylons, inventory, and vehicle textures to a respawned vehicle.
	Only executed on the server. Will execute commands as local where required.
	Designed to be called directly from the "Expression" field of a vehicle respawn module.
	
	Parameters:
		0: Object - New vehicle
		1: Object - Old vehicle
		
	Returns: Bool
		True if the vehicle was configured correctly
		False if there was an error configuring the vehicle
*/

#include "script_macros.hpp"

// Only run on the server
if (!isServer) exitWith {};

params [
	["_newVeh",objNull,[objNull]],
	["_oldVeh",objNull,[objNull]]
];

// Grab the vehicle setup information (stored on vehicle postInit)
private _vehicleData = _newVeh getVariable "xpt_vehicle_respawnData";

// If we don't have any vehicle data, exit
if (isNil "_vehicleData") exitWith {};

// Start the vehicle setup

// Set the vehicle textures
{
	_newVeh setObjectTextureGlobal [_forEachIndex, _x];
} forEach (_vehicleData get "textures");

// Configure pylons
private _pylonsConfig = [];
{
	_pylonsConfig pushBack [_x # 0, _x # 1, true, _x # 2];
} forEach (_vehicleData get "pylons");
[_newVeh, _pylonsConfig] call XPT_fnc_configurePylons;

// Configure animations
// Code grabbed from BIS_fnc_loadVehicle
{
	_x set [2,true];
	_newVeh animate _x;
	_newVeh animateDoor _x;
} forEach (_vehicleData get "animations");

// Add inventory items
clearItemCargoGlobal _newVeh;
clearBackpackCargoGlobal _newVeh;
clearWeaponCargoGlobal _newVeh;
clearMagazineCargoGlobal _newVeh;

private _itemCargo = _vehicleData get "itemCargo";
{
	private _count = (_itemCargo select 1) select _forEachIndex;
	_newVeh addItemCargoGlobal [_x,_count];
} forEach (_itemCargo select 0);

private _backpackCargo = _vehicleData get "backpackCargo";
{
	private _count = (_backpackCargo select 1) select _forEachIndex;
	_newVeh addBackpackCargoGlobal [_x,_count];
} forEach (_backpackCargo select 0);

private _weaponCargo = _vehicleData get "weaponCargo";
{
	private _count = (_weaponCargo select 1) select _forEachIndex;
	_newVeh addWeaponCargoGlobal [_x,_count];
} forEach (_weaponCargo select 0);

private _magazineCargo = _vehicleData get "magazineCargo";
{
	private _count = (_magazineCargo select 1) select _forEachIndex;
	_newVeh addMagazineCargoGlobal [_x,_count];
} forEach (_magazineCargo select 0);

// Configure datalink
private _datalink = _vehicleData get "datalink";
_newVeh setVehicleReportRemoteTargets (_datalink # 0);
_newVeh setVehicleReceiveRemoteTargets (_datalink # 1);
_newVeh setVehicleReportOwnPosition (_datalink # 2);