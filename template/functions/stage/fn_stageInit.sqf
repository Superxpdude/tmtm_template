/*
	XPT_fnc_stageInit
	Author: Superxpdude
	Initialises the mission "Stage" system. Called automatically in preInit
	
	Parameters:
		None
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Initialize stage variables
_defaultStage = (getMissionConfigValue "XPT_stageDefault");
if (isClass ((getMissionConfig "CfgXPT") >> "stages" >> _newStage)) then {
	XPT_stage_active = _defaultStage;
} else {
	XPT_stage_active = "stage_base";
	[[true, format ["[XPT-STAGE] Default stage <%1> does not exist", _newStage]]] remoteExec ["XPT_fnc_errorReport", 0];
};
publicVariable "XPT_stage_active";