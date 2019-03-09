/*
	XPT_fnc_errorLog
	Author: Superxpdude
	Handles sending an error message to the rpt log, and to the in-game system chat if required.
	This function should never be called directly. Please use XPT_fnc_error instead.
	
	Parameters:
		0: Bool - Priority. "True" marks a message as a critical message, ensuring that it gets reported in systemChat regardless of the debugMode setting.
		1: String - Log Message. Completed message to display in the rpt log and system chat.
	
	Returns: Nothing
*/

#include "xpt_script_defines.hpp"

// Define variables
params [
	["_priority", false, [false]],
	["_log", nil, [""]]
];

private _debug = (["XPT_debugMode", 0] call BIS_fnc_getParamValue);

// Log an error if no error message was sent
if (isNil "_log") exitWith {
	_priority = true;
	_log = "Could not log error, no message sent."
};

// Write the log messages
diag_log (text _log);
if (_priority OR (_debug == 1)) then {
	systemChat _log;
};