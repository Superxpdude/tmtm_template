/*
	XPT_fnc_logWrite
	Author: Superxpdude
	Handles writing an error message to the rpt log. Sends the message to the in-game system chat if required.
	This function should never be called directly. Please use XPT_fnc_log instead.
	
	Parameters:
		0: String - Log Message. Written to the RPT log.
		1: String or Boolean - Chat Message. Written to systemChat if a string. Ignored if a boolean.
	
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define variables
params [
	["_log", false, ["",false]],
	["_chat", false, ["",false]]
];

// Log an error if no error message was sent
if !(_log isEqualType "") exitWith {
	[2,"Could not log error. No message sent"] call XPT_fnc_log;
};

// Write the log messages
diag_log (text _log);
if (_chat isEqualType "") then {
	systemChat _chat;
};