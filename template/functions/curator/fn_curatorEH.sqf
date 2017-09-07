/*
	XPT_fnc_curatorEH
	Author: Superxpdude
	Adds event handlers to all curators upon mission start. Executed automatically in postInit
	Executes on all clients to ensure correct execution of eventHandlers.
	
	Parameters: None
		
	Returns: Nothing
*/
// Entire function is in a forEach loop so that it applies to all curator modules.
{
	// Add event handler to share placed units between curators
	_x addEventHandler ["CuratorObjectPlaced", {_this remoteExec ["XPT_fnc_curatorObjPlaced", 2]}];
	
	// Add event handler to share placed groups between curators
	_x addEventHandler ["CuratorObjectPlaced", {_this remoteExec ["XPT_fnc_curatorGrpPlaced", 2]}];
	
	// Add event handler to remove NVGs from spawned units
	if ((getMissionConfigValue "XPT_curator_removeNVG") == 1) then {
		_x addEventHandler ["CuratorObjectPlaced",{_this call XPT_fnc_curatorRemoveNVG;}];
	};
	
	// Add event handler to set custom vehicle cargos
	// Function yet to be added.
	
	// Add event handler to set custom unit loadouts
	// Function yet to be added.
	
	// Add event handler to handle transferring units to headless clients
	// Function yet to be added.
} forEach allCurators;