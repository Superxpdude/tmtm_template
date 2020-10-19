/*
	XPT_fnc_curatorRemoveNVG
	Author: Superxpdude
	Removes night-vision goggles from curator-spawned units.
	Used if you want to make a night-time op without players stealing NVGs from dead enemies
	
	Parameters:
		0: Object - Unit spawned by a curator
		
	Returns: Nothing
*/

// Define variables
params [
	["_curator", nil, [objNull]],
	["_unit", nil, [objNull]]
];
// Exit if the unit is undefined
if (isNil "_unit") exitWith {
	[2, "Called with no unit defined", 0] call XPT_fnc_log;
};

// Determine if the spawned unit is a vehicle or a man
if (_unit isKindOf "Man") then {
	// If the unit is a "Man", check if they have NVGs
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

// Return nothing
nil
