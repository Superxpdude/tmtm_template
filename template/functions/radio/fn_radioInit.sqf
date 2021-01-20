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
	["info", "Adding radio init event handlers"] call XPT_fnc_log;
	["CBA_beforeSettingsInitialized", {
		// Set the script name for error handling
		private _fnc_scriptName = "XPT_fnc_radioInit";
		
		["info", "Initializing radio CBA settings"] call XPT_fnc_log;
		
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
		
		// Only run on actual players, not zeus' or spectators
		if !(_unit isKindOf "VirtualMan_F") then {
			private _settingsArray = _unit getVariable ["XPT_TFAR_savedSRSettings",[]];
			{
				// Get the classnames of the current radio, as well as its base class
				private _radio = _x;
				private _baseRadio = (configfile >> "CfgWeapons" >> _radio >> "tf_parent") call BIS_fnc_getCfgData;
				
				// Check if any previous settings have been saved
				private _savedSettings = (_settingsArray select {(_x select 0) == _baseRadio}) select 0;
				
				// Default frequencies and sides should be automatically set by CBA settings
				// This section is for overrides for channels, alternates, and frequencies
				if !(isNil "_savedSettings") then {
					// If we have saved settings for the radio, copy them to the new one
					[_radio, _savedSettings select 1] call TFAR_fnc_setSwSettings;
				} else {
					// If we don't have saved settings, set new ones using the variables set on the unit or group
					private _channel = _unit getVariable ["XPT_TFAR_SRChannel",(group _unit) getVariable ["XPT_TFAR_SRChannel", _unit getVariable ["TFAR_SRChannel", (group _unit) getVariable ["TFAR_SRChannel", -1]]]];
					private _altChannel = _unit getVariable ["XPT_TFAR_SRAltChannel",(group _unit) getVariable ["XPT_TFAR_SRAltChannel",-1]];
					private _freqs = _unit getVariable ["XPT_TFAR_SRFreqs",(group _unit) getVariable ["XPT_TFAR_SRFreqs",[]]];
					if (_channel >= 0) then {
						[_radio, _channel] call TFAR_fnc_setSwChannel;
					};
					if (_altChannel >= 0) then {
						[_radio, _altChannel] call TFAR_fnc_setAdditionalSwChannel;
					};
					{
						[_radio, (_x # 0) + 1, _x # 1] call TFAR_fnc_setChannelFrequency;
					} forEach _freqs;
				};
			} forEach _radios;
		};
	}] call TFAR_fnc_addEventHandler;
};

// Mark that the radio setup is complete
XPT_radio_setup_complete = true;