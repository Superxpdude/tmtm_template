/*
	XPT_fnc_cbaParams
	Author: Superxpdude
	Sets CBA mission settings based on lobby parameter values.
	
	Parameters:
		Designed to be called during preinit. No parameters.
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// If CBA is not installed, exit with an error
if (!isClass (configfile >> "CfgMods" >> "cba")) exitWith {
	[1, "CBA is not installed, cannot read lobby parameters"] call XPT_fnc_log;
	false
};

// Add a CBA event handler
["CBA_beforeSettingsInitialized", {
	// Find all lobby parameters that are a CBA setting
	private _params = "getNumber (_x >> 'XPT_CBA_setting') > 0" configClasses (missionConfigFile >> "params");
	
	// Loop through each lobby parameters
	{
		// Grab the parameter name
		private _paramName = configName _x;
		// Use the parameter name to grab the parameter value
		private _paramValue = [_paramName] call BIS_fnc_getParamValue;
		
		private _paramMod = [(_x >> "XPT_modifier") call BIS_fnc_getCfgData] param [0,nil,[""]];
		
		// If we have a modifier, apply it to the result before we set the CBA setting
		if (!isNil "_paramMod") then {
			_paramValue = call compile format [_paramMod, _paramValue];
		};
		
		// Set the CBA setting from the parameter's value
		["CBA_settings_setSettingMission", [_paramName, _paramValue, true]] call CBA_fnc_localEvent;
		[3, format ["Setting CBA setting [%1] to [%2]",_paramName, _paramValue]] call XPT_fnc_log;
	} forEach _params;
	
	// Find all lobby parameters that affect multiple CBA settings
	private _multiparams = "getNumber (_x >> 'XPT_CBA_multiSetting') > 0" configClasses (missionConfigFile >> "params");
	
	// Loop through each lobby parameters
	{
		// Grab the parameter name
		private _paramName = configName _x;
		// Use the parameter name to grab the parameter value
		private _paramValue = [_paramName] call BIS_fnc_getParamValue;
		
		// Grab our array of parameter values
		private _paramArray = [(_x >> "XPT_paramArray") call BIS_fnc_getCfgData] param [0,nil,[[]]];
		
		// Iterate through the sub-array to set CBA settings
		{
			["CBA_settings_setSettingMission", [_x select 0, _x select 1, true]] call CBA_fnc_localEvent;
			[3, format ["Setting CBA setting [%1] to [%2]",_paramName, _paramValue]] call XPT_fnc_log;
		} forEach (_paramArray select _paramValue);
	} forEach _multiparams;
	
}] call CBA_fnc_addEventHandler;

true 