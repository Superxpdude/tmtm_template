// Function called at mission start to set up event handlers for curators
private ["_objPlaced"];
_objPlaced = ["_this remoteExec ['SXP_fnc_objPlaced', 2]"];

// Figure out if we need to remove NVGs from curator spawned units
if (getMissionConfigValue "SXP_zeus_removeNVGs") then {
	_objPlaced append ["_this remoteExec ['SXP_fnc_objPlaced', 2]"];
};

// Add the event handlers to all curators
{
	_x addEventHandler ["CuratorObjectPlaced",compile (_objPlaced joinString "; ")];
	_x addEventHandler ["CuratorGroupPlaced",{_this remoteExec ["SXP_fnc_grpPlaced", 2];}];
} forEach allCurators;