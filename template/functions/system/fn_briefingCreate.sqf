/*
	XPT_fnc_briefingCreate
	Author: Superxpdude
	Creates a player briefing using classes defined in XPTBriefings.hpp
	
	Parameters: Array of any number of entries of the following types (both types can be used in the same array)
		0: String - Class of briefing to create
		OR
		0: Config - Config class to create the briefing from
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only run on a machine with a player
if (!hasInterface) exitWith {};

// Create a sub-function (needed for error handling to work properly)
private ["_briefingFunc"];
_briefingFunc = {
	// Define parameters
	_briefing = param [0, nil, ["", configNull]];
	// Exit if the briefing is undefined
	if (isNil "_briefing") exitWith {
		[2, "XPT_fnc_briefingCreate called with incorrect variable type"] call XPT_fnc_log;
	};
	
	// If the briefing is a string, find the correct class
	if ((typeName _briefing) == "STRING") then {
		_briefing = ((getMissionConfig "CfgXPT") >> "briefings" >> _briefing);
	};
	
	// If the class doesn't exist, return an error
	if (!(isClass _briefing)) exitWith {
		[1, format ["Missing briefing class [%1]", _briefing]] call XPT_fnc_log;
	};
	
	// Now that we know the config exists, grab the rest of our variables
	private ["_category", "_title", "_text", "_sides", "_sideNum"];
	_category = [((_briefing >> "category") call BIS_fnc_getCfgData)] param [0, nil, [""]];
	_title = [((_briefing >> "entryName") call BIS_fnc_getCfgData)] param [0, nil, [""]];
	_text = [((_briefing >> "entryText") call BIS_fnc_getCfgData)] param [0, nil, [""]];
	_sides = [((_briefing >> "sides") call BIS_fnc_getCfgData)] param [0, nil, [[]]];
	
	if ((isNil "_category") OR (isNil "_title") OR (isNil "_text") OR (isNil "_sides")) exitWith {
		[1,format ["Briefing class [%1] is missing a config value", configName _briefing]] call XPT_fnc_log;
	};
	
	// Grab a number based on the player side
	_sideNum = switch (side player) do {
		case west: {0};
		case east: {1};
		case independent: {2};
		case civilian: {3};
		case sideLogic: {4};
	};
	
	// Check if the player side is in the sides array.
	if ((_sideNum in _sides) or (-1 in _sides)) then {
		// If the sides match up, create the diary record.
		player createDiaryRecord [_category, [_title,_text]];
	};
};

// Execute the loop
{
	[_x] call _briefingFunc;
} forEach _this;