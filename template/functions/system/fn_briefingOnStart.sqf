/*
	XPT_fnc_briefingOnStart
	Author: Superxpdude
	Automatically creates briefings on mission start
	
	Parameters:
		Designed to be called in postInit
		
	Returns: Nothing
*/

// Only run on a machine with a player
if (!hasInterface) exitWith {};

// Define variabls
private ["_briefings", "_sideNum", "_sides"];

// Grab a list of briefing configs with the onStart flag
_briefings = "getNumber (_x >> 'onStart') == 1" configClasses ((getMissionConfig "CfgXPT") >> "briefings");

// Check if the player side is in the defined sides
switch (side player) do {
	case west: {_sideNum = 0};
	case east: {_sideNum = 1};
	case independent {_sideNum = 2};
	case civilian {_sideNum = 3};
};

// Create the briefings
{
	// Grab the list of briefing sides
	_sides = [((_x >> "sides") call BIS_fnc_getCfgData)] param [0, nil, [[]]];
	// Make sure sides is defined
	if (!(isNil "_sides")) then {
		// Check if the player side is in the briefing define
		if (_sideNum in _sides) then {
			// Create the briefing
			[_x] call XPT_fnc_briefingCreate;
		};
	};
} forEach _briefings;