/*
	XPT_fnc_radioInit
	Author: Superxpdude
	Handles setting up radio settings.
	Must be executed on all clients
	
	Parameters: None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Check if the template's radio system is enabled
private _enable = getMissionConfigValue ["XPT_radio_enable", 1];

if (_enable == 1) then {
	["CBA_beforeSettingsInitialized", {
		// Set the script name for error handling
		private _fnc_scriptName = "XPT_fnc_radioInit";
		
		// Define variables
		private ["_settingsSWWest", "_settingsSWEast", "_settingsSWGuer", "_bluCode", "_opCode", "_indepCode", "_codesDisabled"];
		private _settingsSW = "100,110,120,130,140,150,160,170,180";
		private _settingsLR = "50,55,60,65,70,75,80,85,90,95";
		
		// Check if PVP is enabled
		private _isPVP =  if (getMissionConfigValue ["XPT_isPVP", 0] == 1) then {true} else {false};
		
		// If the mission is PVP, we want to use different frequencies and codes for each side
		if (_isPVP) then {
			_codesDisabled = false;
			// TFAR frequencies are now defined as an array in string form
			_settingsSWWest = "100,110,120,130,140,150,160,170,180";
			_settingsSWEast = "200,210,220,230,240,250,260,270,280";
			_settingsSWGuer = "300,310,320,330,340,350,360,370,380";
			_bluCode = "_blufor";
			_opCode = "_opfor";
			_indepCode = "_independent";
		} else {
			_codesDisabled = true;
			_settingsSWWest = _settingsSW;
			_settingsSWEast = _settingsSW;
			_settingsSWGuer = _settingsSW;
			_bluCode = "_disabled";
			_opCode = "_disabled";
			_indepCode = "_disabled";
		};
		
		// Define our settings array (to loop through to set the CBA settings)
		private _settings = [
			["tfar_radioCodesDisabled", _codesDisabled, true], // Enable radio codes if mission is PVP
			["TFAR_giveLongRangeRadioToGroupLeaders", false, true], // Group leaders have LRs in loadouts
			["TFAR_givePersonalRadioToRegularSoldier", true, true], // All loadouts have radios defined
			["TFAR_SameSRFrequenciesForSide", true, true], // Use the same frequencies for the whole side
			["TFAR_SameLRFrequenciesForSide", true, true], // Use the same frequencies for the whole side
			["TFAR_setting_defaultFrequencies_sr_west", _settingsSWWest, true],
			["TFAR_setting_defaultFrequencies_sr_east", _settingsSWEast, true],
			["TFAR_setting_defaultFrequencies_sr_independent", _settingsSWGuer, true],
			["TFAR_setting_defaultFrequencies_lr_west", _settingsLR, true],
			["TFAR_setting_defaultFrequencies_lr_east", _settingsLR, true],
			["TFAR_setting_defaultFrequencies_lr_independent", _settingsLR, true],
			["tfar_radiocode_west", _bluCode, true],
			["tfar_radiocode_east", _opCode, true],
			["tfar_radiocode_independent", _indepCode, true]
		];
		
		// Loop through the settings array
		{		
			// Set the CBA setting
			["CBA_settings_setSettingMission", _x] call CBA_fnc_localEvent;
		} forEach _settings;
	}] call CBA_fnc_addEventHandler;
	
	// Add an event handler to assign radio information on respawn.
	// TODO: rewrite this at some point to be more efficient (and less error prone)
	["xpt_tfar_onRadiosReceived", "OnRadiosReceived", {
		params ["_unit", "_radios"];
		// Do not run if the player is a zeus
		if !(_unit isKindOf "VirtualMan_F") then {
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
		};
	}] call TFAR_fnc_addEventHandler;
};

// Mark that the radio setup is complete
XPT_radio_setup_complete = true;