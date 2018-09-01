/*
	XPT_fnc_vehicleSetup
	Author: Superxpdude
	Handles setting up a vehicle from a predefined config.
	Will automatically execute itself where the vehicle is local.
	
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
if (isNil "_vehicle") exitWith {
	[[true,"[XPT-VEHICLE] XPT_fnc_vehicleSetup called with no vehicle defined."]] remoteExec ["XPT_fnc_errorReport", 0];
	false
};

// Execute the function where the vehicle is local
if (!local _vehicle) exitWith {
	if (!isServer) then {
		// If this has been run on a client, send it to the server to find the object owner
		_this remoteExec ["XPT_fnc_vehicleSetup", 2];
	} else {
		// If this has been run on the server, find out who the owner is and send it to them
		_this remoteExec ["XPT_fnc_vehicleSetup", owner _vehicle];
	};
};

// Find the config that we need if it's not already defined

if (isNil "_loadout") then {
	// Search the vehicle's variables to find a loadout
	_loadout = _vehicle getVariable ["XPT_loadout", nil];
	
	// If the loadout is still undefined, grab the classname
	if (isNil "_loadout") then {
		_loadout = (typeOf _vehicle);
	};
};

/*
if (isNil "_loadout") then {
	switch true do {
		case (!isNil (_vehicle getVariable ["XPT_loadout", nil])): {_vehicle getVariable ["XPT_loadout", nil]};
		default {_loadout = _class};
	};
};
*/
// Determine the config path of the vehicle loadout
_config = ((getMissionConfig "CfgXPT") >> "vehicleSetup" >> _loadout);

// If the class doesn't exist, return an error
if (!(isClass _config)) exitWith {
	[[false, format ["[XPT-VEHICLE] Missing Loadout: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
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
	// TODO:
	// Define variables in this section using the "params" command
	// Rewrite section to execute turret settings where turret is local
	
	// Grab the path of the turret in question
	_turretPath = (_x select 0);
	
	// Check if turret weapons has any entries, and if it does, apply those entries
	if ((count (_x select 1)) > 0) then {
		// If any weapons have been defined, remove all existing weapons
		{
			//_vehicle removeWeaponTurret [_x,_turretPath];
		} forEach (_vehicle weaponsTurret _turretPath);
		
		// Add the new turret weapons
		{
			_vehicle addWeaponTurret [_x,_turretPath];
		} forEach (_x select 1);
	};
	
	// Check if turret magazines has any entries, and if it does, apply those entries
	if ((count (_x select 2)) > 0) then {
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
		} forEach (_x select 2);
	};

	// Set the lock status of the turret
	// Convert the number to a boolean
	switch (_x select 3) do {
		case 0: {_x set [3, false]};
		case 1: {_x set [3, true]};
		default {_x set [3, nil]}; // Set the value to nil if it's not a 1 or 0
	};
	// If the desired lock status is defined, set it.
	if (!isNil {_x select 3}) do {
		_vehicle lockTurret [_turretPath, _x select 3];
	};
	
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