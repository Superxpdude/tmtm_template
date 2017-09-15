/*
	XPT_fnc_mapMarkersClient
	Author: Superxpdude
	Unhides map markers of friendly groups in TvT missions.
	Called automatically from XPT_fnc_mapMarkersServer
	
	Parameters:
		0: String - Name of map marker
		1: Group - Group attached to the marker
		
	Returns: Nothing
*/

// Don't run on servers or headless clients
if (!hasInterface) exitWith {};

// Define parameters
params ["_marker", "_group"];

// Check if the group is friendly to the player
if ([(side player), (side _group)] call BIS_fnc_sideIsFriendly) then {
	// If the sides are friends, show the marker
	_marker setMarkerAlphaLocal 1;
};