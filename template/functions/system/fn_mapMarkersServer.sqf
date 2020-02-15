/*
	XPT_fnc_mapMarkersServer
	Author: Superxpdude
	Handles creating and updating group-markers on the map.
	
	Parameters:
		Designed to be called from a lobby parameter
		Can also be re-executed manually using the following command:
			[true] call XPT_fnc_mapMarkersServer
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only to be run on the server
if (!isServer) exitWith {};

// Only to be run if map markers are enabled
if ((_this select 0) == 0) exitWith {};

// Do not execute if there are already map markers present, this would indicate that the function is already running
if (!isNil "XPT_mapMarkersList") exitWith {
	[1, "Second XPT_fnc_mapMarkersServer instance started while another instance was already running", 2] call XPT_fnc_log;
};
	

// Spawn map markers loop (since this function is called on mission start)
[] spawn {
	private _fnc_scriptName = "XPT_fnc_mapMarkersServer";
	// Define our variables
	private ["_groups", "_markers", "_tempMarkers", "_markerType"];
	_markers = [];
	
	// Mark the map markers as enabled
	XPT_mapMarkersEnabled = true;
	
	[3, "Starting map markers loop", 0] call XPT_fnc_log;
	
	// Start the loop
	while {XPT_mapMarkersEnabled} do {
		// Clear the groups list
		_groups = [];
		// Fill tempMarkers will variables from markers
		_tempMarkers = + _markers;
		// Fill the groups list with player groups
		{
			// Ensure that we exclude zeus groups
			if (isPlayer (leader _x) AND (((leader _x) getVariable ["XPT_zeusUnit", false]) isEqualTo false)) then {
				_groups pushBackUnique _x
			};
		} forEach allGroups;
		
		// Start updating map markers
		{
			// Define more variables
			private ["_x", "_grpMarker", "_markerType"];
			// Check if the group has a marker already
			_grpMarker = _x getVariable ["XPT_mapMarker", nil];
			if (isNil "_grpMarker") then {
				// If the group does not yet have a marker, create one
				_grpMarker = createMarker [format ["%1", _x], getPosATL (leader _x)];
				_grpMarker setMarkerShape "ICON";
				// If the mission is a PvP mission, hide the marker on all machines
				if ((getMissionConfigValue "XPT_isPVP") == 1) then {
					_grpMarker setMarkerAlpha 0;
				};
				// Get the correct marker type based on the group's side
				_markerType = switch (side _x) do {
					case west: {"b_unknown"};
					case east: {"o_unknown"};
					case resistance: {"n_unknown"};
					case civilian: {"c_unknown"};
					default {"b_unknown"};
				};
				_grpMarker setMarkerType _markerType;
				_grpMarker setMarkerPos (getPosATL (leader _x));
				_grpMarker setMarkerText (groupID _x);
				_grpMarker setMarkerSize [0.75, 0.75];
				// Add the new marker to the markers array
				_markers pushBackUnique _grpMarker;
				// Set a variable on the group referencing the new marker
				_x setVariable ["XPT_mapMarker", _grpMarker, true];
				
			} else {
				// If the group already has a marker, just update it
				_grpMarker setMarkerPos (getPosATL (leader _x));
				_grpMarker setMarkerText (groupID _x);
			};
			_tempMarkers = _tempMarkers - [_grpMarker];
		} forEach _groups;
		
		// Check if any markers are missing a group, and delete them
		if ((count _tempMarkers) > 0) then {
			{
				_markers = _markers - [_x];
				deleteMarker _x;
			} forEach _tempMarkers;
		};
		// Broadcast the markers list to all clients
		XPT_mapMarkersList = _markers;
		// If the mission is a PVP mission, tell the clients to unhide friendly markers
		if ((getMissionConfigValue "XPT_isPVP") == 1) then {
			[_groups] remoteExec ["XPT_fnc_mapMarkersClient", 0];
		};
		publicVariable "XPT_mapMarkersList";
		// Wait a few seconds
		sleep 5;
	};
	
	// If the map markers become disabled at any point, delete all of the current map markers
	{
		deleteMarker _x;
	} forEach XPT_mapMarkersList;
	// Set the map markers list to nil. This allows the markers to be restarted at any point
	XPT_mapMarkersList = nil;
	// Update the map markers array on all clients
	publicVariable "XPT_mapMarkersList";
};