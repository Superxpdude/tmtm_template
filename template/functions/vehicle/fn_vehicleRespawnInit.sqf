/*
	XPT_fnc_vehicleRespawnInit
	Author: Superxpdude
	Handles preparing a vehicle for the automated respawn function.
	Executed during postInit.
	
	Parameters:
		None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only run on the server
if (!isServer) exitWith {};

{
	private _module = _x;
	private _vehicles = [_module, "AllVehicles", false] call BIS_fnc_synchronizedObjects;
	{
		// Get some prerequisite variables
		private _vehicle = _x;
		private _vehicleType = typeOf _vehicle;
		private _vehicleData = createHashMap; // Create our hashmap to store all of the vehicle info
		
		// Get vehicle textures
		private _textures = getObjectTextures _vehicle;
		
		// Get pylons info
		private _pylons = [];
		{
			// Store the pylon name, magazine, and turret
			_pylons pushBack [_x # 1, _x # 3, _x # 2];
		} forEach (getAllPylonsInfo _vehicle);
		
		// Get a list of animations and their states
		private _animations = [];
		// Grab a list of animation sources
		private _animationSources = configProperties [configFile >> "CfgVehicles" >> _vehicleType >> "animationSources","isclass _x",true];
		{
			_animName = configName _x;
			_animations pushback [_animName, _vehicle animationPhase _animName];
		} forEach _animationSources;
		
		// Get a list of inventory items
		private _itemCargo = getItemCargo _vehicle;
		private _backpackCargo = getBackpackCargo _vehicle;
		private _weaponCargo = getWeaponCargo _vehicle;
		private _magazineCargo = getMagazineCargo _vehicle;
		
		// Get datalink status
		private _datalink = [
			vehicleReportRemoteTargets _vehicle,
			vehicleReceiveRemoteTargets _vehicle,
			vehicleReportOwnPosition _vehicle
		];
		
		
		// Start saving variables onto the vehicle
		{
			_vehicleData set [_x # 0, _x # 1];
		} forEach [
			["pylons", _pylons],
			["textures", _textures],
			["animations", _animations],
			["itemCargo", _itemCargo],
			["backpackCargo", _backpackCargo],
			["weaponCargo", _weaponCargo],
			["magazineCargo", _magazineCargo],
			["datalink", _datalink]
		];
		
		_vehicle setVariable ["xpt_vehicle_respawnData", _vehicleData, true];
		
	} forEach _vehicles;
} forEach (entities "ModuleRespawnVehicle_F");