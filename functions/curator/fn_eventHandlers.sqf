// Function called at mission start to set up event handlers for curators
private ["_objPlaced"];
_objPlaced = ["_this remoteExec ['SXP_fnc_objPlaced', 2]"];

// Figure out if we need to remove NVGs from curator spawned units
if ((getMissionConfigValue "SXP_zeus_removeNVGs") == 1) then {
	_objPlaced append ["_this remoteExec ['SXP_fnc_objPlaced', 2]"];
};

// Figure out if we need to set custom vehicle cargos
if ((getMissionConfigValue "SXP_customVehicleCargo") == 1) then {
	_objPlaced append ["_this call SXP_fnc_setVehicleCargo"];
};

// Figure out if we need to set custom unit loadouts
if ((getMissionConfigValue "SXP_zeus_customLoadouts") == 1) then {
	_objPlaced append ["_this call SXP_fnc_setUnitLoadouts"];
};

// Add the event handlers to all curators
{
	_x addEventHandler ["CuratorObjectPlaced",compile (_objPlaced joinString "; ")];
	_x addEventHandler ["CuratorGroupPlaced",{_this remoteExec ["SXP_fnc_grpPlaced", 2];}];
} forEach allCurators;