// Function called at mission start to set up event handlers for curators
// Add the event handlers to all curators
{
	_x addEventHandler ["CuratorObjectPlaced",{_this remoteExec ["SXP_fnc_objPlaced", 2];}];
	
	// Add event handler to remove NVGs
	if ((getMissionConfigValue "SXP_zeus_removeNVGs") == 1) then {
		_x addEventHandler ["CuratorObjectPlaced",{_this call SXP_fnc_zeusRemoveNVGs;}];
	};
	
	// Add event handler to set custom vehicle cargos
	if ((getMissionConfigValue "SXP_customVehicleCargo") == 1) then {
		_x addEventHandler ["CuratorObjectPlaced",{_this call SXP_fnc_setVehicleCargo;}];
	};
	
	// Add event handler to set custom unit loadouts
	if ((getMissionConfigValue "SXP_customLoadouts") == 1) then {
		_x addEventHandler ["CuratorObjectPlaced",{_this call SXP_fnc_setUnitLoadouts;}];
	};
	
	// Add event handler to handle curator units and headless clients
	if (("headlessclient" call BIS_fnc_getParamValue) == 1) then {
		_x addEventHandler ["CuratorObjectPlaced",{[(group (_this select 1))] remoteExec ["SXP_fnc_hcSetGroupOwner", 2];}];
	};
	_x addEventHandler ["CuratorGroupPlaced",{_this remoteExec ["SXP_fnc_grpPlaced", 2];}];
} forEach allCurators;