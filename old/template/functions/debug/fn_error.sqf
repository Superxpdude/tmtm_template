/*
	XPT_fnc_error
	Author: Superxpdude
	Handles errors that may occur within the template scripts.
	Allows for error reporting on a single machine, or multiple machines.
	
	Debug mode can be enabled from the lobby parameters.
	Error messages will always be reported to the RPT.
	However, they will only be reported in-game if they are marked as a critical error, or debug mode is on.
	
	General rule of thumb is critical errors should always be reported both in the RPT and in-game.
	Minor errors should only be reported in-game if debug mode is on.
	
	Parameters:
		0: Bool - Priority. "True" marks a message as a critical message, ensuring that it gets reported in systemChat regardless of the debugMode setting.
		1: String - Error message. Descriptive text to describe what went wrong.
			OR
		1: Array - Contains the following values:
			1.0: String - Module Name. Used to distinguish which "part" of the template is throwing an error. Function name of calling script used when undefined.
			1.1: String - Error message.
		2: Number (Optional) - Location. Uses the following values:
			0 - Will only log the error on the machine upon which the error occured.
			1 - Will log the error on the machine, as well as the server.
			2 - Will log the error on all connected machines.
			Default value (when missing) is 0.
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
params [
	["_priority", false, [false]],
	["_error", nil, ["",[]],2],
	["_location", 0, [0]]
];

private ["_module", "_message"];

// Log an error (heh) if any variables are missing or invalid.
if (isNil "_error") exitWith {
	[2, format ["Deprecated function XPT_fnc_error called from [%1] with no message defined",_fnc_scriptNameParent]] call XPT_fnc_log;
};

// If the error message is a string, convert it to an array
if !(_error isEqualType []) then {
	_error = [nil, _error];
};

_error params [
	["_module", _fnc_scriptNameParent, [""]],
	["_message", nil, [""]]
];

if (_priority) then {
	[1, [_module,_message],_location] call XPT_fnc_log;
} else {
	[2, [_module,_message],_location] call XPT_fnc_log;
};
[2, format ["Deprecated function XPT_fnc_error called from [%1]",_fnc_scriptNameParent],_location] call XPT_fnc_log;