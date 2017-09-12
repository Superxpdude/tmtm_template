/*
	XPT_fnc_updateTask
	Author: Superxpdude
	Simplified version of updateTask
	Uses a collection of script files found outside the mission folder
	
	Parameters:
		0: String - Task update to run
		
	Returns: Nothing
*/

// Only execute on the server. Tasks should only ever be created server-side
if (!isServer) exitWith {};

param ["_script", nil, [""]];

if (isNil "_script") exitWith {
	[[false, "[XPT-TASKS] XPT_fnc_updateTask was called with an incorrect parameter."]] remoteExec ["XPT_fnc_errorReport", 0]
};

// Task updates section
[] execVM "mission\taskUpdates\" + _script + ".sqf";