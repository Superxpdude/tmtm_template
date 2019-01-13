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
		1: String - Module name. Used to distinguish which "part" of the template is throwing an error.
		2: String - Error message. Descriptive text to describe what went wrong.
		3: Number (Optional) - Location. Uses the following values:
			0 - Will only log the error on the machine upon which the error occured.
			1 - Will log the error on the machine, as well as the server.
			2 - Will log the error on all connected machines.
			Default value (when missing) is 0.
		
	Returns: Nothing
*/

#include xpt_script_defines.hpp

// Define variables
params [
	["_priority", false, [false]],
	["_module", nil, [""]],
	["_message", nil, [""]],
	["_location", 0, [0]]
];

// Grab the debug mode status
private _debug = (["XPT_debugMode", 0] call BIS_fnc_getParamValue);

// Log an error (heh) if any variables are missing or invalid.
if (isNil "_module") exitWith {
	[true, "XPT_DEF_MODULE", "XPT_fnc_error called with no module defined", 0] call XPT_fnc_error;
};
if (isNil "_message") exitWith {
	[true, "XPT_DEF_MODULE", "XPT_fnc_error called with no message defined", 0] call XPT_fnc_error;
};
if ((_location > 2) OR (_location < 0)) exitWith {
	[true, "XPT_DEF_MODULE", format ["XPT_fnc_error called with invalid location of: %1", _location], 0] call XPT_fnc_error;
};

// Build our message
private _log = text (format ["[%1] %2"]);

// Send our message
switch (_location) do {
	case 0: {diag_log _log;};
	case 1: {
		diag_log _log;
		_log remoteExec ["diag_log", 2];
	};
	case 2: {_log remoteExec ["diag_log", 0];};
};