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
	private _module = _x
	private _vehicles = [_module, "AllVehicles", false] call BIS_fnc_synchronizedObjects;
	{
		// Get some prerequisite variables
		private _vehicle = _x;
		private _vehicleType = typeOf _vehicle;
		
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
		// Grab only animation sources that are supposed to be changed by the user
		private _animationSources = "((_x >> 'source') call BIS_fnc_getCfgData) == 'user'" configClasses (configFile >> "CfgVehicles" >> _vehicleType >> "AnimationSources");
		{
			_animations pushBack [_x,_vehicle animationSourcePhase _x];
		} forEach _animationSources;
		
		// Get a list of inventory items
		private _itemCargo = getItemCargo _vehicle;
		private _backpackCargo = backpackCargo _vehicle;
		
		// Get datalink status
		private _datalink = [
			vehicleReportRemoteTargets _vehicle,
			vehicleReceiveRemoteTargets _vehicle,
			vehicleReportOwnPosition _vehicle
		];
		
		
		// Start saving variables onto the vehicle
		{
			_vehicle setVariable [_x # 0, _x # 1, true];
		} forEach [
			["xpt_vehicle_respawn_pylons", _pylons],
			["xpt_vehicle_respawn_textures", _textures],
			["xpt_vehicle_respawn_animations", _animations],
			["xpt_vehicle_respawn_itemCargo", _itemCargo],
			["xpt_vehicle_respawn_backpackCargo", _backpackCargo],
			["xpt_vehicle_respawn_datalink", _datalink]
		];
		
	} forEach _vehicles;
} forEach (entities "ModuleRespawnVehicle_F");