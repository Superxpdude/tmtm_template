/*
	XPT_fnc_radioInit
	Author: Superxpdude
	Handles setting up radio settings.
	Must be executed on all clients
	
	Parameters: None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
private ["_settingsSW", "_settingsLR", "_settingsSWWest", "_settingsSWEast", "_settingsSWGuer"];

// Get variables from mission config
private _enable = getMissionConfigValue ["XPT_radio_enable", 1];
private _isPVP = getMissionConfigValue ["XPT_isPVP", 0];

if (_enable == 1) then {
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
	} else {
		_settingsSW = "100,110,120,130,140,150,160,170,180";
		_settingsSWWest = _settingsSW;
		_settingsSWEast = _settingsSW;
		_settingsSWGuer = _settingsSW;

		// If not a PVP, disable radio codes entirely:
		["tfar_radioCodesDisabled", true, true, "mission"] call CBA_settings_fnc_set;
	};

	_settingsLR = "50,55,60,65,70,75,80,85,90,95";

	// This won't work, TFAR frequency settings are defined in CBA settings as strings
	["TFAR_setting_defaultFrequencies_sr_west", _settingsSWWest, true, "mission"] call CBA_settings_fnc_set;
	["TFAR_setting_defaultFrequencies_sr_east", _settingsSWEast, true, "mission"] call CBA_settings_fnc_set;
	["TFAR_setting_defaultFrequencies_sr_independent", _settingsSWGuer, true, "mission"] call CBA_settings_fnc_set;

	["TFAR_setting_defaultFrequencies_lr_west", _settingsLR, true, "mission"] call CBA_settings_fnc_set;
	["TFAR_setting_defaultFrequencies_lr_east", _settingsLR, true, "mission"] call CBA_settings_fnc_set;
	["TFAR_setting_defaultFrequencies_lr_independent", _settingsLR, true, "mission"] call CBA_settings_fnc_set;

	["xpt_tfar_onRadiosReceived", "OnRadiosReceived", { 
		params ["_unit", "_radios"];
		private _radio = _radios select 0; // Only worry about the first radio given
		// Grab the prototype radio classname
		_srRadio = (configfile >> "CfgWeapons" >> _radio >> "tf_parent") call BIS_fnc_getCfgData;
		
		// Check if any previous settings have been saved
		// Settings are stored in an array that contains the classname of the radio, as well as a saved copy of TFAR_fnc_getSwSettings.
		private _srSettings = _unit getVariable ["XPT_savedSRSettings", nil];
		// Grab the classname of the old radio
		private _oldRadio = if (isNil "_srSettings") then {"none"} else {_srSettings select 0};
		// Grab the side of the new radio. (The encryption code allows us to determine what side the radio belongs to).
		private _radioSide = (configfile >> "CfgWeapons" >> _srRadio >> "tf_encryptionCode") call BIS_fnc_getCfgData;
		
		// If any SR settings have been defined, assign them to the player's radio
		// Only do so if the classnames match between the radios, and the server has finished setting up radios.
		if ((!isNil "_srSettings") AND (_oldRadio == _srRadio)) then {
			[call TFAR_fnc_activeSwRadio, (_srSettings select 1)] call TFAR_fnc_setSwSettings;
		} else {
			// If we have no saved data, or the classnames don't match, generate default values
			private _srSettings = ["",[false] call TFAR_fnc_generateSrSettings];
			// Set the radio frequencies and encryption codes
			switch (_radioSide) do {
				case "tf_west_radio_code": {
					(_srSettings select 1) set [2,TFAR_defaultFrequencies_sr_west];
					(_srSettings select 1) set [4,tf_west_radio_code];
				};
				case "tf_east_radio_code": {
					(_srSettings select 1) set [2,TFAR_defaultFrequencies_sr_east];
					(_srSettings select 1) set [4,tf_east_radio_code];
				};
				case "tf_independent_radio_code": {
					(_srSettings select 1) set [2,TFAR_defaultFrequencies_sr_independent];
					(_srSettings select 1) set [4,tf_independent_radio_code];
				};
			};
			// Set the default channel. Grab the value from the player unit first, otherwise try the group. If both don't exist, use the default (channel 0).
			(_srSettings select 1) set [0, (_unit getVariable ["TFAR_SRChannel", ((group _unit) getVariable ["TFAR_SRChannel", 0])])];
			// Assign the radio settings
			[call TFAR_fnc_activeSwRadio, (_srSettings select 1)] call TFAR_fnc_setSwSettings;
		};
	}] call TFAR_fnc_addEventHandler;
};

// Mark that the radio setup is complete
XPT_radio_setup_complete = true;