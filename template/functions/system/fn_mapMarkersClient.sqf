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

#include "script_macros.hpp"

// Don't run on servers or headless clients
if (!hasInterface) exitWith {};

// Define parameters
params ["_groups"];

// Iterate through all groups passed to the client
{
	if (_x isEqualType grpNull) then {
		private _grpMarker = _x getVariable ["XPT_mapMarker", nil];
		if !(isNil "_grpMarker") then {
			// Group has a map marker. Check if they are friendly
			if ([playerSide, (side _x)] call BIS_fnc_sideIsFriendly) then {
				// Group is friendly
				_grpMarker setMarkerAlphaLocal 1;
			} else {
				// Group is not friendly
				_grpMarker setMarkerAlphaLocal 0;
			};
		};
	};
} forEach _groups;
