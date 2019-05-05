/*
	XPT_fnc_cbaParams
	Author: Superxpdude
	Sets CBA mission settings based on lobby parameter values.
	
	Parameters:
		Designed to be called during preinit. No parameters.
		
	Returns: Nothing
*/

#include "xpt_script_defines.hpp"

// If CBA is not installed, exit with an error
if (!isClass (configfile >> "CfgMods" >> "cba")) exitWith {
	[true, "CBA is not installed, cannot read lobby parameters", 0] call XPT_fnc_error;
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
		
		// Set the CBA setting from the parameter's value
		["CBA_settings_setSettingMission", [_paramName, _paramValue, true]] call CBA_fnc_localEvent;
	} forEach _params;
	
}] call CBA_fnc_addEventHandler;

true 