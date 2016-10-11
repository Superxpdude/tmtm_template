// Function to handle group map markers
if ((_this select 0) == 0) exitWith {};

[] spawn {
	private ["_groups", "_markers", "_tempMarkers", "_markerType"];
	while {true} do {
		// Clear the groups list
		_groups = [];
		// Fill tempMarkers with variables from markers
		_tempMarkers = _markers;
		// Fill the groups list with player groups
		{
			if (isPlayer (leader _x)) then {
				_groups pushBackUnique _x;
			};
		};
		// Start updating markers for all groups
		{
			// Check if the group already has a marker
			private ["_x", "_grpMarker", "_markerType"];
			_grpMarker = _x getVariable ["SXP_mapMarker", nil];
			if (isNil "_grpMarker") then {
				// If the group does not yet have a marker, create one
				_grpMarker = createMarker [format ["%1", _x], getPosATL (leader _x)];
				// Get the correct marker type based on the group's side
				_markerType = switch (side _x) do {
					case west: {"b_unknown"};
					case east: {"o_unknown"};
					case resistance: {"n_unknown"};
					case civilian: {"c_unknown"};
					default {"b_unknown"};
				};
				_grpMarker setMarkerType = _markerType;
				_grpMarker setMarkerPos (getPosATL (leader _x));
				_grpMarker setMarkerText (groupID _x);
				_grpMarker setMarkerSize [0.75, 0.75];
				// Add the new marker to the markers array
				_markers pushBackUnique [_grpMarker, _x];
				_tempMarkers pushBackUnique [_grpMarker, _x];
				// Set a variable on the group referencing the new marker
				_x setVariable ["SXP_mapMarker", _grpMarker, true];
				// If the mission is a PVP mission, tell the clients to hide markers of other sides
				if (getMissionConfigValue "SXP_isPVP") then {
					[[_grpMarker, _x]] remoteExec ["SXP_fnc_mapMarkersLocal", 0];
				};
			} else {
				// If the group already has a marker, just update it
				_grpMarker setMarkerPos (getPosATL (leader _x));
				_grpMarker setMarkerText (groupID _x);
			};
			_tempMarkers = _tempMarkers - [_grpMarker, _x];
		} forEach _groups;
		// If there are any markers that are missing a group, then delete them
		if ((count _tempMarkers) > 0) then {
			{
				_markers = _markers - _x;
				deleteMarker (_x select 0);
			} forEach _tempMarkers;
		};
		// Broadcast the markers list to all clients
		SXP_mapMarkersList = _markers;
		publicVariable "SXP_mapMarkersList";
		// Wait a few seconds
		sleep 5;
	};
};
