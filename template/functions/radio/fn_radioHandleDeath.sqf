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

#include "script_macros.hpp"

_unit = _this param [0, player, [objNull]];

// Don't run on Zeus units
if ((_unit isKindOf "VirtualMan_F") or (_unit getVariable ["XPT_zeusUnit", false])) exitWith {};

// Get the list of player radios
_radios = [] call acre_api_fnc_getCurrentRadioList;
// Iterate through all radios, and get their current channels
// This may cause inconsistencies when the player has multiple radios of the same type
{
	switch (toUpper ([_x] call acre_api_fnc_getBaseRadio)) do {
		case "ACRE_PRC343": {
			_unit setVariable ["XPT_ACRE_channel_343", [_x] call acre_api_fnc_getRadioChannel, true];
			_unit setVariable ["XPT_ACRE_spatial_343", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_PRC148": {
			_unit setVariable ["XPT_ACRE_channel_148", [_x] call acre_api_fnc_getRadioChannel, true];
			_unit setVariable ["XPT_ACRE_spatial_148", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_PRC152": {
			_unit setVariable ["XPT_ACRE_channel_152", [_x] call acre_api_fnc_getRadioChannel, true];
			_unit setVariable ["XPT_ACRE_spatial_152", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_PRC117F": {
			_unit setVariable ["XPT_ACRE_channel_117", [_x] call acre_api_fnc_getRadioChannel, true];
			_unit setVariable ["XPT_ACRE_spatial_117", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_SEM52SL": {
			_unit setVariable ["XPT_ACRE_channel_sem52", [_x] call acre_api_fnc_getRadioChannel, true];
			_unit setVariable ["XPT_ACRE_spatial_sem52", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_PRC77": {
			_unit setVariable ["XPT_ACRE_spatial_77", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		case "ACRE_SEM70": {
			_unit setVariable ["XPT_ACRE_spatial_sem70", [_x] call acre_api_fnc_getRadioSpatial, true];
		};
		default {} // Do nothing for other radios
	};
} forEach _radios;

// Store the player push to talk assignments
_ptt = [] call acre_api_fnc_getMultiPushToTalkAssignment;
{
	_ptt set [_forEachIndex, [_x] call acre_api_fnc_getBaseRadio];
} forEach _ptt;
_unit setVariable ["XPT_ACRE_ptt", _ptt];