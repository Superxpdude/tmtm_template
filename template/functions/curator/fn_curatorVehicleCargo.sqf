/*
	XPT_fnc_curatorVehicleCargo
	Author: blah2355
	Sets custom cargo to Zeus spawned vehicles and box objects.
	
	Parameters:
		0: Object - Vehicle or box spawned by a curator
		
	Returns: Nothing
*/

params [
	["_curator", nil, [objNull]],
	["_vehicle", nil, [objNull]]
];

// Exit if the vehicle is undefined
if (isNil "_vehicle") exitWith {
	[2, "Called with no vehicle defined", 0] call XPT_fnc_log;
};

// Retrieve vehicle data from the config files
private _itemCargo = [((_class >> "itemCargo") call BIS_fnc_getCfgData)] param [0, nil, [""]];

// Set up cargo
[_vehicle, _itemCargo, true, true] call XPT_fnc_loadItemCargo;
