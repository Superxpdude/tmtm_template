/*
	XPT_fnc_radioInit
	Author: Superxpdude
	Handles setting up radio settings.
	
	Parameters: None
		
	Returns: Nothing
*/

// Define variables
private ["_isPVP", "_settingsSW", "_settingsLR", "_settingsSWWest", "_settingsSWEast", "_settingsSWGuer"];

// Most (if not all) of this stuff should only be run on the server
//if (!isServer) exitWith {};

// Check if the mission is a PVP mission
_isPVP = getMissionConfigValue "XPT_isPVP";

// Set basic TFAR settings
["TFAR_giveLongRangeRadioToGroupLeaders", false, true, "mission"] call CBA_settings_fnc_set; // Don't automatically give group leaders radio backpacks
["TFAR_givePersonalRadioToRegularSoldier", true, true, "mission"] call CBA_settings_fnc_set; // Give regular soldiers good radios instead of terrible rifleman radios
["TFAR_SameSRFrequenciesForSide", true, true, "mission"] call CBA_settings_fnc_set; // Use the same short range frequencies for every squad
["TFAR_SameLRFrequenciesForSide", true, true, "mission"] call CBA_settings_fnc_set; // Use the same long range frequencies for every squad

// Set frequencies depending on if the mission is PVP or not
if (_isPVP == 1) then {
	// TFAR frequencies are now defined as an array in string form
	// Set frequencies for BLUFOR
	_settingsSWWest = "100,110,120,130,140,150,160,170,180";
	// Set frequencies for OPFOR
	_settingsSWEast = "200,210,220,230,240,250,260,270,280";
	// Set frequencies for Independent
	_settingsSWGuer = "300,310,320,330,340,350,360,370,380";
	
	// Set the radio encryption codes
	//["tf_west_radio_code", "_radio_west", true, "mission"] call CBA_settings_fnc_set;
	//["tf_east_radio_code", "_radio_east", true, "mission"] call CBA_settings_fnc_set;
	//["tf_guer_radio_code", "_radio_guer", true, "mission"] call CBA_settings_fnc_set;
	//tf_west_radio_code = "_radio_west";
	//tf_east_radio_code = "_radio_east";
	//tf_guer_radio_code = "_radio_guer";
	
} else {
	_settingsSW = "100,110,120,130,140,150,160,170,180";
	_settingsSWWest = _settingsSW;
	_settingsSWEast = _settingsSW;
	_settingsSWGuer = _settingsSW;
	
	// Set the radio encryption codes
	//["tf_west_radio_code", "_radio", true, "mission"] call CBA_settings_fnc_set;
	//["tf_east_radio_code", "_radio", true, "mission"] call CBA_settings_fnc_set;
	//["tf_guer_radio_code", "_radio", true, "mission"] call CBA_settings_fnc_set;
	
	//tf_west_radio_code = "_radio";
	//tf_east_radio_code = "_radio";
	//tf_guer_radio_code = "_radio";
	
	// If not a PVP, disable radio codes entirely:
	["tfar_radioCodesDisabled", true, true, "mission"] call CBA_settings_fnc_set;
};

_settingsLR = "50,55,60,65,70,75,80,85,90,95";

// This won't work, TFAR frequency settings are defined in CBA settings as strings
["TFAR_setting_defaultFrequencies_sr_west", _settingsSWWest, true, "mission",true] call CBA_settings_fnc_set;
["TFAR_setting_defaultFrequencies_sr_east", _settingsSWEast, true, "mission"] call CBA_settings_fnc_set;
["TFAR_setting_defaultFrequencies_sr_independent", _settingsSWGuer, true, "mission"] call CBA_settings_fnc_set;

["TFAR_setting_defaultFrequencies_lr_west", _settingsLR, true, "mission"] call CBA_settings_fnc_set;
["TFAR_setting_defaultFrequencies_lr_east", _settingsLR, true, "mission"] call CBA_settings_fnc_set;
["TFAR_setting_defaultFrequencies_lr_independent", _settingsLR, true, "mission"] call CBA_settings_fnc_set;

// Mark that the radio setup is complete
XPT_radio_setup_complete = true;

// Broadcast all variables to clients
{
	publicVariable _x;
} forEach [
	"XPT_radio_setup_complete"
];
