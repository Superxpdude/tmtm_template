// Script for creating player tasks
// Only to be run on the server. BIS_fnc_taskCreate is global.
if (!isServer) exitWith {};

// Example task syntax below
/*
[
	true, // Owners of the task. See wiki page for details
	["task name", "parent task name"], // Name of the task, along with parent name. Parent name is used for nested tasks
	["description", "title", "marker"], // Information about the task. Honestly don't know what the marker does. Leave it blank.
	[0,0,0], // Task destination, can also refer to object location. Good method to use is getMarkerPos. Use objNull for task without location.
	10, // Task priority. Taken into account when automatically assigning new tasks when previous tasks are completed.
	true, // Show notification. Leave this as true. Set to false to disable task popup
	"attack", // Task type. Types can be found in CfgTaskTypes, or at https://community.bistudio.com/wiki/Arma_3_Tasks_Overhaul#Appendix
	true // Share task. If true, game will report which players have the task selected.	
] call BIS_fnc_taskCreate;
*/

if (isNil "zeus_unit") then {
	// Put initial tasks here
} else {
	// Put second copy of tasks here.
	// Due to a bug in BIS_fnc_taskCreate, zeus will not be set as an owner unless explicitly defined.
	// However, if zeus isn't present, trying to use the object will throw script errors.
	// Copy the tasks from above into this section, and replace the owner with an array
	// Example: true, would turn into [true, zeus_unit],
};