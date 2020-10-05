/*
	XPT_fnc_radioMarkers
	Author: Superxpdude
	Creates radio frequency map markers on mission start
	
	Parameters: None. Executed from postInit
	
	Returns; Nothing
*/

#include "scripts_macros.hpp"

// Only run on the server
if (!isServer) exitWith {};

// TODO: check if the marker even exists

// Grab some marker info
private _markerName = "xpt_radioMarker_start";

private _markerType = getMarkerType _markerName;
private _startPos = getMarkerPos _markerName;

// Remove the existing marker now that we have the position
deleteMarker _markerName;

// Start creating our frequency markers
private _posDiff = 0;
private _groupList = allGroups select {isPlayer (leader _x) OR {!isNil {_x getVariable "XPT_TFAR_SRChannel"}}};

{
	private _groupName = groupID _x;
	private _colour = switch (side _x) do {
		case west: {"colorBLUFOR"};
		case east: {"colorOPFOR"};
		case independent: {"colorIndependent"};
		default {"colorCivilian"};
	};
} forEach _groupList;