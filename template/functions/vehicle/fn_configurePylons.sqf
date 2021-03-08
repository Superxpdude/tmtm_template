/*
	XPT_fnc_configurePylons
	Author: Superxpdude
	Configures pylons for a vehicle, and automatically removes weapons that are no longer in use.
	Must be executed where vehicle is local.
	
	Parameters:
		0: Object - Vehicle to assign pylons to
		1: Array containing any number of arrays of pylon configs (same format as setPylonLoadout)
			0: Number/String - Pylon Index or Pylon Name
			1: String - Pylon magazine name
			2: Bool (Optional) - Forced. True to force incompatible magazines.
			3: Array (Optiona) - Turret path for weapon.		

	Returns: Bool
		True if the pylons were set correctly
		False if there was an error
*/

params [
	["_vehicle",objNull,[objNull]],
	["_pylons",[],[[]]]
];

// If the vehicle does not exist, exit
if (isNull _vehicle) exitWith {
	["warning","Called with null vehicle."] call XPT_fnc_log;
	false
};

// If the vehicle is not local, exit
if (!local _vehicle) exitWith {
	["warning","Vehicle is not local. Cannot configure pylons."] call XPT_fnc_log;
	false
};

// Set the pylons on the vehicle
//{
//	_x param ["_pylonID",-1,[0,""]];
//	if (_x < 0) exitWith {};
//	
//	// Find the existing info for the pylon
//	private _allPylonInfo = getAllPylonsInfo _vehicle;
//	// Find the old pylon based on either the index or ID
//	private _oldPylonInfo = _allPylonInfo select (_allPylonInfo findIf {_pylonID in [_x # 0, _x # 1]});
//	private _oldTurret = _oldPylonInfo # 2; // Get the old pylon turret
//	private _oldPylonMag = _oldPylonInfo # 3; // Get the old pylon magazine
//	private _oldPylonWeapon = (configFile >> "CfgMagazines" >> _oldPylonMag >> "pylonWeapon") call BIS_fnc_getCfgData;
//	
//	// Set the new pylon weapon
//	_vehicle setPylonLoadout _x;
//	
//	// Grab all pylons that are on the old turret
//	private _oldTurretPylons = (getAllPylonsInfo _vehicle) select {(_x # 2) == _oldTurret};
//	private _oldTurretWeapons = _oldTurretPylons apply {(configFile >> "CfgMagazines" >> (_x # 3) >> "pylonWeapon") call BIS_fnc_getCfgData};
//	// Check if any pylons still on the old pylon turret use the old pylon weapon
//	if !(_oldPylonWeapon in _oldTurretWeapons) then {
//		// If not present in the old weapons on that turret, remove it from that turret.
//		[_vehicle,[_oldPylonWeapon,_oldTurret]] remoteExec ["removeWeaponTurret",0];
//	};
//} forEach _pylons;

// Store a list of turret weapons to see if we need to remove any of them
private _pylonWeapons = [];
private _pylonsInfo = getAllPylonsInfo _vehicle;
{
	private _turretID = _x;
	private _turretPylons = _pylonsInfo select {(_x # 2) isEqualTo _turretID};
	_pylonWeapons pushBack [_x,_turretPylons apply {(configFile >> "CfgMagazines" >> (_x # 3) >> "pylonWeapon") call BIS_fnc_getCfgData}];
} forEach (allTurrets [_vehicle,false]);

// Set the pylons on the vehicle
{
	_vehicle setPylonLoadout _x;
} forEach _pylons;

private _newPylonsInfo = getAllPylonsInfo _vehicle;

// Clear out old turret weapons from removed pylons
{
	private _turretID = _x # 0;
	private _turretWeapons = _x # 1;
	
	// Grab a list of pylons on the turret
	private _turretPylons = _newPylonsInfo select {(_x # 2) isEqualTo _turretID};
	private _newPylonWeapons = _turretPylons apply {(configFile >> "CfgMagazines" >> (_x # 3) >> "pylonWeapon") call BIS_fnc_getCfgData};
	{
		if !(_x in _newPylonWeapons) then {
			_vehicle removeWeaponTurret [_x, _turretID];
		};
	} forEach _turretWeapons;
} forEach _pylonWeapons;