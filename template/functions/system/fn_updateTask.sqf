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

// If an incorrect parameter type was used, throw an error and exit.
if (isNil "_taskUpdate") exitWith {
	[false, "Called with an incorrect parameter type.", 0] call XPT_fnc_error;
};

// If the updateTask class doesn't exist, throw an error and exit.
if (!(isClass ((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate))) exitWith {
	[true, format ["Task update class <%1> does not exist", _taskUpdate], 0] call XPT_fnc_error;
};

// Grab our variables
private ["_code", "_briefings", "_tasksCreated", "_tasksAssigned", "_tasksSucceeded", "_tasksFailed", "_tasksCancelled"];
_code = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "code") call BIS_fnc_getCfgData)] param [0, "", [""]];
_briefings = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "briefings") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_tasksCreated = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "tasksCreated") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_tasksAssigned = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "tasksAssigned") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_tasksSucceeded = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "tasksSucceeded") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_tasksFailed = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "tasksFailed") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_tasksCancelled = [(((getMissionConfig "CfgXPT") >> "taskUpdates" >> _taskUpdate >> "tasksCancelled") call BIS_fnc_getCfgData)] param [0, [], [[]]];

// Define a sub-function for updating task states. Makes the code more compact
private ["_taskFunc"];
_taskFunc = {
	params [
		["_tasks", [], [[]]],
		["_state", "", [""]]
	];
	
	// Start the task update loop
	{
		if ([_x] call BIS_fnc_taskExists) then {
			// If the task exists, update its status
			[_x, _state, true] call BIS_fnc_taskSetState;
		} else {
			// If the task doesn't exist, return an error
			[true, format ["Task <%1> does not exist", _x], 0] call XPT_fnc_error;
		};
	} forEach _tasks;
};

// Create our briefings. Needs to be put in the JIP queue to ensure JIP players have an up-to-date briefing
_briefings remoteExec ["XPT_fnc_briefingCreate",0,true];

// Update the tasks
{
	_x call _taskFunc;
} forEach [
	[_tasksCreated, "CREATED"],
	[_tasksAssigned, "ASSIGNED"],
	[_tasksSucceeded, "SUCCEEDED"],
	[_tasksFailed, "FAILED"],
	[_tasksCancelled, "CANCELED"]
];
// Execute the code portion
[] call compile _code;