/*
	XPT_fnc_vehicleSetup
	Author: Superxpdude
	Handles setting up a vehicle from a predefined config.
	
	Parameters:
		0: Object - Vehicle to configure
		1: String (Optional) - Loadout to apply. Uses vehicle classname if undefined. Searches in XPTVehicleSetup.hpp
		
	Returns: Bool
		True if the vehicle was configured correctly
		False if there was an error configuring the vehicle
*/

// Define variables
private ["_vehicle", "_class", "_loadout", "_config", "_subclasses"];
params [
	["_vehicle", nil, [objNull]],
	["_loadout", nil, [""]]
];

// Exit the script if the vehicle is undefined.
if (isNil "_vehicle") exitWith {false};

// Find the classname of the vehicle
_class = (typeOf _vehicle);

// Find the config that we need if it's not already defined
/*
if (isNil "_loadout") then {
	// Search the vehicle's variables to find a loadout
	_loadout = _vehicle getVariable ["XPT_loadout", nil];
	
	// If the loadout is still undefined, grab the classname
	if (isNil "_loadout") then {
		_loadout = _class;
	};
};
*/
switch true do {
	case (!isNil (_vehicle getVariable ["XPT_loadout", nil])): {_vehicle getVariable ["XPT_loadout", nil]};
	default {_loadout = _class};
};

// Determine the config path of the vehicle loadout
_config = ((getMissionConfig "CfgXPT") >> "vehicleSetup" >> _loadout);

// If the class doesn't exist, return an error
if (!(isClass _config)) exitWith {
	[[false, format ["[XPT-VEHICLE] Missing Loadout: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
};

// Check if there are any sub-loadouts for the vehicle
_subclasses = "true" configClasses _class;
if ((count _subclasses) > 0) then {
	// If there are any subclasses, select a random one.
	_class = selectRandom _subclasses;
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
	/////////////////////////////////////////////////////
	/// SCRIPT FOR ITEMCARGO HAS NOT BEEN WRITTEN YET ///
	/////////////////////////////////////////////////////
};

// Configure pylons
{
	_vehicle setPylonLoadout _x;
} forEach _pylons;

// Configure turrets

////////////////////////////////
/// SECTION NOT YET COMPLETE ///
////////////////////////////////

// Start a loop to iterate through all defined turrets
{
	private ["_turretPath"];
	// Grab the path of the turret in question
	_turretPath = (_x select 0);
	
	// Check if turret weapons has any entries, and if it does, apply those entries
	if ((count (_x select 1)) > 0) then {
		////////////////////////////////
		/// SECTION NOT YET COMPLETE ///
		////////////////////////////////
	};
	
	// Check if turret magazines has any entries, and if it does, apply those entries
	if ((count (_x select 2)) > 0) then {
		////////////////////////////////
		/// SECTION NOT YET COMPLETE ///
		////////////////////////////////
	};

	// Set the lock status of the turret
	////////////////////////////////
	/// SECTION NOT YET COMPLETE ///
	////////////////////////////////
	
} forEach _turretConfigs;

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
	if ((_datalink select 0) != -1) then {
		_vehicle setVehicleReportOwnPosition (_datalink select 0);
	};
	if ((_datalink select 1) != -1) then {
		_vehicle setVehicleReportRemoteTargets (_datalink select 1);
	};
	if ((_datalink select 2) != -1) then {
		_vehicle setVehicleReceiveRemoteTargets (_datalink select 2);
	};
};