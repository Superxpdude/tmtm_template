// Function to handle group map markers
if ((_this select 0) == 0) exitWith {};
[] spawn {
	private ["_groups", "_markers", "_markerType"];
	while {true} do {
		// Clear the groups list
		_groups = [];
		// Clear the markers list
		_markers = [];
		// Fill the groups list with friendly player groups
		{
			if (((side _x) == (side (group player))) && (isPlayer (leader _x))) then {
				_groups pushBackUnique _x;
			};
		} forEach allGroups;
		// Update markers for all groups
		{
			private ["_marker", "_markerType", "_x"];
			// Get the correct marker type based on the side of the group
			_markerType = switch (side _x) do {
				case west: {"b_unknown"};
				case east: {"o_unknown"};
				case resistance: {"n_unknown"};
				case civilian: {"c_unknown"};
				default {"b_unknown"};
			};
			_marker = createMarker [format ["%1", _x], getPosATL (leader _x)];
			_marker setMarkerType _markerType;
			_marker setMarkerPos (getPosATL (leader _x));
			_marker setMarkerText (groupID _x);
			_marker setMarkerSize [0.75, 0.75];
			_markers pushBackUnique _marker;
		} forEach _groups;
		// After creating and moving markers, wait 5 seconds before the next update.
		sleep 5;
		// Clean up old markers
		{
			deleteMarker _x
		} forEach _markers;
	};
};