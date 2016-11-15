// SXP_fnc_mapMarkersLocal
// Local component of map markers script. Only runs during PVP missions. Not to be run on dedicated machines
// Hides markers of other sides during PVP matches
if (isDedicated) exitWith {};
if (!(getMissionConfigValue "SXP_isPVP")) exitWith {};

// Run through each marker passed to the script, and determine if we need to hide it
{
	private ["_x"];
	// Check if the side of the group is friendly to the side of the player
	if (!([(side player), (side (_x select 1))] call BIS_fnc_sideIsFriendly)) then {
		// If the sides are not friends, hide the marker
		(_x select 0) setMarkerAlphaLocal 0;
	};
} forEach _this;