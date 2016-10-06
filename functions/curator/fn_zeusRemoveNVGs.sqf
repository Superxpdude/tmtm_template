// fn_zeusRemoveNVGs.sqf
// Removes NVGs from zeus-spawned units
// Designed to be run within a curatorObjectPlaced event handler
// Only to be run on the server
if (!isServer) exitWith {};
private "_unit";
_unit = _this select 1;

// Determine if the unit is infantry or a vehicle
if (_unit isKindOf "Man") then {
	// If the unit spawned is of type "man", check if they have NVGs
	if ((hmd _unit) != "") then {
		// If the unit has NVGs, get rid of them
		_unit unlinkItem (hmd _unit);
	};
} else {
	// If the unit is a not a man, check if it has a crew
	if ((count (crew _unit)) > 0) then {
		// If the unit has a crew, run through them one by one and remove their NVGs if they have them
		{
			if ((hmd _x) != "") then {
			// If the unit has NVGs, remove them
				_x unlinkItem (hmd _x);
			};
		} forEach (crew _unit);
	};
};