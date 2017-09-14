/*
	XPT_fnc_briefingCreate
	Author: Superxpdude
	Creates a player briefing using classes defined in XPTBriefings.hpp
	
	Parameters:
		0: String - Class of briefing to create
		OR
		0: Config - Config class to create the briefing from
		
	Returns: Nothing
*/

// Only run on a machine with a player
if (!hasInterface) exitWith {};

// Define parameters
params [
	["_briefing", nil, ["", configNull]]
];

// Exit if the briefing doesn't exist.
if (isNil "_briefing") exitWith {[false,"[XPT-BRIEFING] XPT_fnc_briefingCreate called with incorrect variable type."] call "XPT_fnc_errorReport";};

// If the briefing is a string, find the correct class
if ((typeName _briefing) == "STRING") then {
	if (isClass ((getMissionConfig "CfgXPT") >> "briefings" >> _briefing)) then {
		_briefing = ((getMissionConfig "CfgXPT") >> "briefings" >> _briefing);
	} else {
		[true, format ["[XPT-BRIEFING] Briefing class <%1> doesn't exist", _briefing]] call "XPT_fnc_errorReport";
	};
};

// Now that we have the main config, we need to grab more variables
private ["_category", "_title", "_text", "_sides"];
_category = [((_briefing >> "category") call BIS_fnc_getCfgData)] param [0, nil, [""]];
_title = [((_briefing >> "entryName") call BIS_fnc_getCfgData)] param [0, nil, [""]];
_text = [((_briefing >> "entryText") call BIS_fnc_getCfgData)] param [0, nil, [""]];
_sides = [((_briefing >> "sides") call BIS_fnc_getCfgData)] param [0, nil, [[]]];

// If we're missing a value, exit the function and throw an error message
if ((isNil "_category") OR (isNil "_title") OR (isNil "_text") OR (isNil "_sides")) exitWith {
	[true,format ["[XPT-BRIEFING] Briefing class <%1> is missing a config value", configName _briefing]] call "XPT_fnc_errorReport";
};

// Create the briefing
player createDiaryRecord [_category, [_title,_text]];