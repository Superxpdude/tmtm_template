/*
	XPT_fnc_radioHandleDeath
	Author: Superxpdude
	Handles assigning radio channels when a player respawns.
	Only handles radio channels. Will not preserve other settings such as channel names, volume, or stereo settings.
	
	Parameters:
		Designed to be called directly from onPlayerKilled
		
	Returns: Nothing
*/
// Define variables
_unit = _this param [0, player, [objNull]];

// Don't run on Zeus units
if ((_unit isKindOf "VirtualMan_F") or (_unit getVariable ["XPT_zeusUnit", false])) exitWith {};

// Get the list of player radios
_radios = [] call acre_api_fnc_getCurrentRadioList;
// Iterate through all radios, and get their current channels
// This may cause inconsistencies when the player has multiple radios of the same type
{
	switch (toLower ([_x] call acre_api_fnc_getBaseRadio)) do {
		case "ACRE_PRC343": {
			_unit setVariable ["ACRE_channel_343", [_x] call acre_api_fnc_getRadioChannel, true];
		};
		case "ACRE_PRC148": {
			_unit setVariable ["ACRE_channel_148", [_x] call acre_api_fnc_getRadioChannel, true];
		};
		case "ACRE_PRC152": {
			_unit setVariable ["ACRE_channel_152", [_x] call acre_api_fnc_getRadioChannel, true];
		};
		case "ACRE_PRC117F": {
			_unit setVariable ["ACRE_channel_117", [_x] call acre_api_fnc_getRadioChannel, true];
		};
		case "ACRE_SEM52SL": {
			_unit setVariable ["ACRE_channel_sem52", [_x] call acre_api_fnc_getRadioChannel, true];
		};
		default {} // Do nothing for other radios
	};
} forEach _radios;