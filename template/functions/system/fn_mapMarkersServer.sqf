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
	["error", "Second XPT_fnc_mapMarkersServer instance started while another instance was already running", "all"] call XPT_fnc_log;
};

// Spawn map markers loop (since this function is called on mission start)
[] spawn {
	private _fnc_scriptName = "XPT_fnc_mapMarkersServer";
	// Define our variables
	private ["_groups", "_markers", "_tempMarkers", "_markerType"];
	_markers = [];
	
	// Mark the map markers as enabled
	XPT_mapMarkersEnabled = true;
	
	["info", "Starting map markers loop", 0] call XPT_fnc_log;
	
	// Start the loop
	while {XPT_mapMarkersEnabled} do {
		// Clear the groups list
		_groups = [];
		// Fill tempMarkers will variables from markers
		_tempMarkers = + _markers;
		// Fill the groups list with player groups
		{
			// Ensure that we exclude virtual entities
			if (isPlayer (leader _x) AND !((leader _x) isKindOf "VirtualMan_F") AND !(_x getVariable ["XPT_disableMapMarker", false])) then {
				_groups pushBackUnique _x
			};
		} forEach allGroups;
		
		// Start updating map markers
		{
			// Define more variables
			private ["_x", "_grpMarker", "_markerPrefix", "_markerSuffix", "_markerType"];
			// Check if the group has a marker already
			_grpMarker = _x getVariable ["XPT_mapMarker", ""];
			if ((getMarkerType _grpMarker) == "") then {_grpMarker = nil};
			if (isNil "_grpMarker") then {
				// If the group does not yet have a marker, create one
				_grpMarker = createMarker [format ["xpt_mapMarker_%1", _x], getPosATL (leader _x)];
				_grpMarker setMarkerShapeLocal "ICON";
				// If the mission is a PvP mission, hide the marker on all machines
				if ((getMissionConfigValue "XPT_isPVP") == 1) then {
					_grpMarker setMarkerAlphaLocal 0;
				};
				// Get the marker prefix based on the group side
				_markerPrefix = switch (side _x) do {
					case west: {"b_"};
					case east: {"o_"};
					case resistance: {"n_"};
					case civilian: {"c_"};
					default {"b_"};
				};
				
				/*
				private _leaderVehicle = vehicle (leader _x);
				_markerSuffix = switch (true) do {
					case (_leaderVehicle isKindOf "Man"): {"inf"};
					case (_leaderVehicle isKindOf "Helicopter"): {"air"};
					case (_leaderVehicle isKindOf "Plane"): {"plane"};
					case (_leaderVehicle isKindOf "Tank"): {"armor"};
					default {"unknown"};
				};
				*/
				_markerSuffix = _x getVariable ["XPT_mapMarkerType", "unknown"];
				
				
				// Get the correct marker type based on the group's side
				/*
				_markerType = switch (side _x) do {
					case west: {"b_unknown"};
					case east: {"o_unknown"};
					case resistance: {"n_unknown"};
					case civilian: {"c_unknown"};
					default {"b_unknown"};
				};
				*/
				
				_markerType = _markerPrefix + _markerSuffix;
				_grpMarker setMarkerTypeLocal _markerType;
				_grpMarker setMarkerPosLocal (getPosATL (leader _x));
				_grpMarker setMarkerTextLocal (groupID _x);
				_grpMarker setMarkerSize [0.75, 0.75]; // Last command is global to broadcast marker state
				// Add the new marker to the markers array
				_markers pushBackUnique _grpMarker;
				// Set a variable on the group referencing the new marker
				_x setVariable ["XPT_mapMarker", _grpMarker, true];
				["debug", format ["Created a map marker for [%1]",_x], "all"] call XPT_fnc_log;
				
			} else {
				// If the group already has a marker, just update it
				_grpMarker setMarkerPosLocal (getPosATL (leader _x));
				_grpMarker setMarkerText (groupID _x);
			};
			_tempMarkers = _tempMarkers - [_grpMarker];
			
			/*
				Marker type suffixes
				x_unknown - Empty marker
				x_inf - Infantry (Two crossed diagonal lines)
				x_motor_inf - Motorized Infantry (Infantry with vertical line)
				x_mech_inf - Mechanized Infantry (Infantry with armour oval)
				x_armor - Armoured (Oval)
				x_recon - Recon (Single diagonal line)
				x_air - Helicopter (Rotor symbol)
				x_plane - Airplane (Infinity symbol)
				x_uav - UAV/Drone (Upside-down chevron)
				x_naval - Boat
				x_med - Medical (Cross)
				x_art - Artillery (Single dot)
				x_mortar - Mortars (Circle with arrow)
				x_hq - Headquarters (Flag)
				x_support - Support (Low horizontal line for logistics)
				x_maint - Maintenance (Wrench)
				x_service - Service (Triangle on right side)
				x_installation - Installation or Base
			*/
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