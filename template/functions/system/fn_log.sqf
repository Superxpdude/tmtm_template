/*
	XPT_fnc_log
	Author: Superxpdude
	Handles writing logs within the template scripts.
	Allows for log reporting on a single machine, or multiple machines.
	
	There are four available log levels
		0: Error - Errors that will impact the operation of a system, but not the entire mission.
		1: Warning - Issues that may result in undesired effects, but will not break systems.
		2: Info - Information regarding the operation of the template.
		3: Debug - Debug information. Not logged unless debug mode is enabled.
	
	Debug mode can be enabled from the lobby parameters.
	Error will always be reported in-game and in the .rpt.
	Warning and Info will always be reported to the .rpt, and will be reported in-game if debug mode is enabled.
	Debug will only be reported to the .rpt if debug mode is enabled.
	
	Parameters:
		0: Number (or string) - Priority. A lower number means a higher priority, see above for details.
		1: String - Error message. Descriptive text to describe what went wrong.
			OR
		1: Array - Contains the following values:
			1.0: String - Module Name. Used to distinguish which "part" of the template is throwing an error. Function name of calling script used when undefined.
			1.1: String - Error message.
		2: Number or string (Optional) - Location. Uses the following values:
			0 (local) - Will only log the error on the machine upon which the error occured.
			1 (server) - Will log the error on the machine, as well as the server.
			2 (all) - Will log the error on all connected machines.
			Default value (when missing) is 0.
		
	Returns: Nothing
	
	Examples:
		Log info message on client and server
		["info", "My info message", 1] call XPT_fnc_log;
		
		Log error message on all clients
		["error", "Oh no everything broke", 2] call XPT_fnc_log;
		
		Log debug message only on client
		["debug", "Debug message"] call XPT_fnc_log;
*/

#include "script_macros.hpp"

// Define variables
params [
	["_priority", 2, [0,""]],
	["_error", nil, ["",[]],2],
	["_location", 0, [0,""]]
];

// Convert a priority string to the number
if (_priority isEqualType "") then {
	_priority = switch (toLower _priority) do {
		case "error": {0};
		case "warning": {1};
		case "info": {2};
		case "debug": {3};
		default {3};
	};
};

// Convert a location string to the number
if (_location isEqualType "") then {
	_location = switch (toLower _location) do {
		case "local": {0};
		case "server": {1};
		case "all": {2};
		default {0};
	};
};

private ["_module", "_message"];

// Grab the debug mode status
private _debug = (["XPT_debugMode", 0] call BIS_fnc_getParamValue);

// If debug is not enabled. Ignore messages marked as debug messages
if ((_priority >= 3) AND (_debug == 0)) exitWith {};

// Log an error (heh) if any variables are missing or invalid.
if (isNil "_error") exitWith {
	["warning", format ["Called from [%1] with no message defined",_fnc_scriptNameParent]] call XPT_fnc_log;
};
if ((_location > 2) OR (_location < 0)) then {
	["warning", format ["Called with invalid location of: [%1]", _location]] call XPT_fnc_log;
	_location = 0; // Set the location to 0 if invalid
};

// If the error message is a string, convert it to an array
if !(_error isEqualType []) then {
	_error = [nil, _error];
};

_error params [
	["_module", _fnc_scriptNameParent, [""]],
	["_message", nil, [""]]
];

// Check to make sure that the message is defined
if (isNil "_message") exitWith {
	["warning", format ["Called from [%1] with no message defined",_module]] call XPT_fnc_log;
};

private _priorityText = switch (_priority) do {
	case 0: {"ERROR"};
	case 1: {"WARNING"};
	case 2: {"INFO"};
	case 3: {"DEBUG"};
	default {"INFO"};
};

// Build our messages
private _logMessage = format ["[%1] (%2) %3",_priorityText,_module,_message];
private _chatMessage = if ((_priority <= 0) OR ((_priority <= 2) AND (_debug == 1))) then {
	format ["[%1] %2",_module,_message]
} else {
	false
};

// Send our message
switch (_location) do {
	// Only the local machine
	case 0: {[_logMessage,_chatMessage] call XPT_fnc_logWrite;};
	// Local machine and server
	case 1: {
		[_logMessage,_chatMessage] call XPT_fnc_logWrite;
		// Only remoteExec to the server if not called on the server.
		if (!isServer) then {
			[_logMessage,_chatMessage] remoteExec ["XPT_fnc_logWrite", 2];
		};
	};
	// All machines
	case 2: {[_logMessage,_chatMessage] remoteExec ["XPT_fnc_logWrite", 0];};
};