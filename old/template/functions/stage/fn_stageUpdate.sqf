/*
	XPT_fnc_stageUpdate
	Author: Superxpdude
	Updates the current stage. Handles switching between stages
	
	Parameters:
		0: String - New stage to change to
		1: Boolean (Optional) - False to prevent stage-ending scripts from running (Default: True)
		2: Boolean (Optional) - False to prevent stage-init scripts from running (Default: True)
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Define parameters
params [
	["_newStage", nil, [""]],
	["_endExec", true, [true]],
	["_initExec", true, [true]]
];

// If the stage is an incorrect variable type, throw an error, and exit.
if (isNil "_newStage") exitWith {
	[[false, "[XPT-STAGE] XPT_fnc_stageUpdate was called with an incorrect parameter type."]] remoteExec ["XPT_fnc_errorReport", 0];
};

// If the new stage class doesn't exist, throw an error, and exit.
if (!(isClass ((getMissionConfig "CfgXPT") >> "stages" >> _newStage))) exitWith {
	[[true, format ["[XPT-STAGE] Stage <%1> does not exist", _newStage]]] remoteExec ["XPT_fnc_errorReport", 0];
};

// Execute the end code from the old stage
if (_endExec) then {
	[] call compile ([(((getMissionConfig "CfgXPT") >> "stages" >> XPT_stage_active >> "endScript") call BIS_fnc_getCfgData)] param [0, "", [""]]);
};

// Update stage variables
XPT_stage_active = _newStage;
publicVariable "XPT_stage_active";

// Execute the init code from the new stage
if (_initExec) then {
	[] call compile ([(((getMissionConfig "CfgXPT") >> "stages" >> XPT_stage_active >> "initScript") call BIS_fnc_getCfgData)] param [0, "", [""]]);
};