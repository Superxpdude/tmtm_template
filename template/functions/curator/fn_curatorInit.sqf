/*
	XPT_fnc_curatorInit
	Author: Superxpdude
	Adds event handlers to all curators upon mission start. Executed automatically in postInit
	Executes on all clients to ensure correct execution of eventHandlers.
	
	Parameters: None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Add a CBA class event handler to apply event handlers to all curator modules (even if they're created mid-mission)
["ModuleCurator_F", "Init", {
	// Grab the curator module
	params ["_module"];
	
	// Set our scriptName for logging
	private _fnc_scriptName = "XPT_fnc_curatorInit";
	
	// Add our normal curator event handlers
	// Share placed units between all curators
	_module addEventHandler ["CuratorObjectPlaced", {_this remoteExec ["XPT_fnc_curatorObjPlaced", 2]}];
	// Share placed groups between all curators
	_module addEventHandler ["CuratorGroupPlaced", {_this remoteExec ["XPT_fnc_curatorGrpPlaced", 2]}];
	// Remove NVGs from spawned units (if enabled)
	if ((getMissionConfigValue "XPT_curator_removeNVGs") == 1) then {
		_module addEventHandler ["CuratorObjectPlaced", {_this call XPT_fnc_curatorRemoveNVG}];
	};
	// Set custom vehicle cargos
	// WIP
	// Set custom unit loadouts
	if ((getMissionConfigValue "XPT_curator_customLoadouts") == 1) then {
		_module addEventHandler ["CuratorObjectPlaced", {_this call XPT_fnc_curatorLoadout}];
	};
	
	// Server only block for curator assignment failsafe
	// if (isServer) then {
	// 	_module addEventHandler ["Local", {_this spawn XPT_fnc_curatorFailsafe}];
	// };
}, nil, nil, true] call CBA_fnc_addClassEventHandler;