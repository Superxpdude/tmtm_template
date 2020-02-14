/*
	XPT_fnc_initServer
	Author: Superxpdude
	Handles template specific entries in initServer
	
	Parameters:
		Designed to be called directly from initServer.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Initialise BIS dynamic groups (server-side)
["Initialize", [true]] call BIS_fnc_dynamicGroups;

// If no blacklisted mission objects have been defined, make an empty array to prevent script errors
if (isNil "XPT_blacklistedMissionObjects") then {
	XPT_blacklistedMissionObjects = [];
};

// Make all initial mission objects editable by all curators
{
	private "_curator";
	_curator = _x;
	{
		// Make sure object is not already in editable objects and is not black listed
		if !(_x in curatorEditableObjects _curator) then {
			_curator addCuratorEditableObjects [[_x], true];
		};
	} forEach playableUnits + switchableUnits + allMissionObjects "LandVehicle" + allMissionObjects "Man" + allMissionObjects "Air" + allMissionObjects "Ship" + allMissionObjects "Reammobox_F" - XPT_blacklistedMissionObjects - allMissionObjects "VirtualMan_F";
} forEach allCurators;

// If enabled, execute the vehicle setup script on start
if (["XPT_vehicleSetup", 0] call BIS_fnc_getParamValue == 1) then {
	{
		[_x, nil, true] call XPT_fnc_vehicleSetup;
	} forEach allMissionObjects "LandVehicle" +  allMissionObjects "Air" + allMissionObjects "Ship";
};