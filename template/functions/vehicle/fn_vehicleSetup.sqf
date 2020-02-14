/*
	XPT_fnc_vehicleSetup
	Author: Superxpdude
	Handles setting up a vehicle from a predefined config.
	Only executed on the server. Will execute commands as local where required.
	
	Parameters:
		0: Object - Vehicle to configure
		1: String (Optional) - Loadout to apply. Uses vehicle classname if undefined. Searches in XPTVehicleSetup.hpp
		2: Bool (Optional) - True when executed on mission start. Suppresses warning about missing loadouts when vehicle classname is used
		
	Returns: Bool
		True if the vehicle was configured correctly
		False if there was an error configuring the vehicle
*/

#include "script_macros.hpp"

// Only execute the main function on the server. This will execute commands on different machines as required.
if (!isServer) exitWith {};

// Define variables
private ["_vehicle", "_class", "_loadout", "_config", "_subclasses", "_onStart"];
params [
	["_vehicle", nil, [objNull]],
	["_loadout", nil, [""]],
	["_onStart", false, [false]]
];

// Exit the script if the vehicle is undefined.
if (isNil "_vehicle") exitWith {
	[1,"XPT_fnc_vehicleSetup called with no vehicle defined."] call XPT_fnc_log;
	false
};

// Find the config that we need if it's not already defined
if (isNil "_loadout") then {
	// Search the vehicle's variables to find a loadout
	_loadout = _vehicle getVariable ["XPT_loadout", nil];
	
	// If the loadout is still undefined, grab the classname
	if (isNil "_loadout") then {
		_loadout = (typeOf _vehicle);
	} else {
		// If the vehicle has a loadout defined, disable the onStart flag.
		_onStart = false;
	};
};

// Determine the config path of the vehicle loadout
_config = ((getMissionConfig "CfgXPT") >> "vehicleSetup" >> _loadout);

// If the class doesn't exist, return an error
if ((!(isClass _config)) AND !(_onStart)) exitWith {
	[1, format ["Missing vehicle config for [%1]", _loadout],2] call XPT_fnc_log;
	false
};

// Check if there are any sub-loadouts for the vehicle
_subclasses = "true" configClasses _config;
if ((count _subclasses) > 0) then {
	// If there are any subclasses, select a random one.
	_class = selectRandom _subclasses;
} else {
	_class = _config;
};

// Retrieve vehicle data from the config files
private ["_displayName", "_itemCargo", "_pylons", "_turretConfigs", "_datalink"];
_displayName = [((_class >> "displayName") call BIS_fnc_getCfgData)] param [0, nil, [""]];
_itemCargo = [((_class >> "itemCargo") call BIS_fnc_getCfgData)] param [0, nil, [""]];
_pylons = [((_class >> "pylons") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_turretConfigs = [((_class >> "turretConfigs") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_datalink = [((_class >> "datalink") call BIS_fnc_getCfgData)] param [0, nil, [[]], 3];

// Begin configuring the vehicle

// Load the item inventory
if (!isNil "_itemCargo") then {
	if (_itemCargo != "") then {
		[_vehicle, _itemCargo, true] call XPT_fnc_loadItemCargo;
	};
};

// Configure turrets

// Start a loop to iterate through all defined turrets
{
	private ["_turretPath"];	
	// Grab the path of the turret in question
	_turretPath = (_x select 0);
	
	// Configure the turret where it is local
	[_vehicle, _x] remoteExec ["XPT_fnc_vehicleSetupTurret", _vehicle turretOwner _turretPath];
	
} forEach _turretConfigs;

// Configure pylons
// Pylons are configured after turrets to prevent pylon weapons from being removed unintentionally.
{
	// Convert the "force" param from a number to bool
	switch (_x select 2) do {
		case 0: {_x set [2, false]};
		case 1: {_x set [2, true]};
		default {_x set [2, nil]}; // Set the value to nil if it's not a 1 or 0
	};
	_vehicle setPylonLoadout _x;
} forEach _pylons;

// Configure datalink
if (!isNil "_datalink") then {
	// Convert the config definitions to usable values
	{
		// Values of -1 don't get adjusted, because they signify no change
		switch _x do {
			case 0: {_datalink set [_forEachIndex, false]};
			case 1: {_datalink set [_forEachIndex, true]};
		};
	} forEach _datalink;
	
	// TODO: Find a way to clean up this section
	if ((typeName (_datalink select 0)) == "BOOL") then {
		_vehicle setVehicleReportOwnPosition (_datalink select 0);
	};
	if ((typeName (_datalink select 1)) == "BOOL") then {
		_vehicle setVehicleReportRemoteTargets (_datalink select 1);
	};
	if ((typeName (_datalink select 2)) == "BOOL") then {
		_vehicle setVehicleReceiveRemoteTargets (_datalink select 2);
	};
};


// Return true if we made it to the end
true