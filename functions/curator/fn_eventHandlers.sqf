// Function called at mission start to set up event handlers for curators
private ["_objPlaced"];

// Figure out if we eed to remove NVGs from curator spawned units
if (getMissionConfigValue "SXP_zeus_removeNVGs") then {
	_objPlaced = {_this remoteExec ["SXP_fnc_objPlaced", 2]; _this remoteExec ["SXP_fnc_zeusRemoveNVGs", 2];};
} else {
	_objPlaced = {_this remoteExec ["SXP_fnc_objPlaced", 2];};
};

// Add the event handlers to all curators
{
	_x addEventHandler ["CuratorObjectPlaced",_objPlaced];
	_x addEventHandler ["CuratorGroupPlaced",{_this remoteExec ["SXP_fnc_objPlaced", 2];}];
} forEach allCurators;