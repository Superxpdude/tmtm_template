// Function for updating mission tasks when objectives are completed.
// Only execute on the server. Tasks should only be created server-side.
if (!isServer) exitWith {};

// Code for task updates goes into these fields. Can be any code required, including new task creation, task state updates, etc.
switch (toLower (_this select 0)) do {
	case "example1": {
		// Setting a task state to completed
		["task1", "SUCCEEDED", true] call BIS_fnc_taskSetState;
	};
	case "example2": {
		// Setting a task state to failed
		["task2", "FAILED", true] call BIS_fnc_taskSetState;
	};
	case "example_newtask": {
		// This check is required to make the tasks show up properly for zeus
		if (isNil "zeus_unit") then {
			// Create the task for cases where zeus doesn't exist
			[true, "task3", ["Demo task 3 description", "Demo Task", ""], objNull, "ASSIGNED", 0, true, "run", true] call BIS_fnc_taskCreate;
		} else {
			// Create the task for cases where zeus exists
			[[true, zeus_unit], "task3", ["Demo task 3 description", "Demo Task", ""], objNull, "ASSIGNED", 0, true, "run", true] call BIS_fnc_taskCreate;
		};
	};
};