/*
	XPT_fnc_updateTask
	Author: Superxpdude
	Simplified version of updateTask
	Calls code stored within a config file in the config directory
	
	Parameters:
		0: String - Task update to run
		
	Returns: Nothing
*/

// Only execute on the server. Tasks should only ever be created server-side
if (!isServer) exitWith {};

params [
	["_taskUpdate", nil, [""]]
];

if (isNil "_taskUpdate") exitWith {
	[[false, "[XPT-TASKS] XPT_fnc_updateTask was called with an incorrect parameter type."]] remoteExec ["XPT_fnc_errorReport", 0]
};

if (!(isClass ((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate))) exitWith {
	[[true, format ["[XPT-TASKS] Task update class <%1> does not exist", _taskUpdate]]] remoteExec ["XPT_fnc_errorReport", 0]
};

// Grab the task update code
_code = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "code") call BIS_fnc_getCfgData)] param [0, nil, [""]];

// If the code doesn't exist. Terminate the function
if (isNil "_code") exitWith {
	[[true, format ["[XPT-TASKS] Task update class <%1> has no code defined", _taskUpdate]]] remoteExec ["XPT_fnc_errorReport", 0]
};

// Execute the code
[] call compile _code;