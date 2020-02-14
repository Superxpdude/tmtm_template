/*
	XPT_fnc_radioInit
	Author: Superxpdude
	Handles setting up radio settings.
	Must be executed on all clients
	
	Parameters: None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

private _enable = getMissionConfigValue ["XPT_acre_enable",1];
private _isPVP = getMissionConfigValue ["XPT_isPVP",0];
private _autobabel = getMissionConfigValue ["XPT_acre_autobabel",0];

private _pvp = if (_isPVP == 1) then {true} else {false};
private _babel = if (_autobabel == 1) then {true} else {false};

if (_enable == 1) then {
	[_babel, _pvp] call acre_api_fnc_setupMission;
};

// Mark that the radio setup is complete
XPT_radio_setup_complete = true;