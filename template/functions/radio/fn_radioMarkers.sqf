/*
	XPT_fnc_radioMarkers
	Author: Superxpdude
	Creates radio frequency map markers on mission start
	
	Parameters: None. Executed from postInit
	
	Returns; Nothing
*/

#include "script_macros.hpp"

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
private _posDiff = 100;
private _groupList = allGroups select {isPlayer (leader _x) OR {!isNil {_x getVariable "XPT_TFAR_SRChannel"}}};

{
	private _group = _x;
	private _groupName = groupID _group;
	private _colour = switch (side _group) do {
		case west: {"colorBLUFOR"};
		case east: {"colorOPFOR"};
		case independent: {"colorIndependent"};
		default {"colorCivilian"};
	};
	private _channel = _group getVariable ["XPT_TFAR_SRChannel", _group getVariable ["TFAR_SRChannel",0]];
	private _freqsArray = (_group getVariable ["XPT_TFAR_SRFreqs", []]) select {(_x # 0) == _channel};
	private _freq = "N/A";
	
	// Find the frequency in use
	switch (true) do {
		// Frequency specified in group
		case ((count _freqsArray) > 0): {
			_freq = (_freqsArray select 0) select 1;
		};
		// Grab frequency from TFAR frequency string
		case ((side _group == west) AND ((count TFAR_setting_defaultFrequencies_sr_west) > 0)): {
			_freq = parseNumber ((TFAR_setting_defaultFrequencies_sr_west splitString ",") select _channel);
		};
		case ((side _group == east) AND ((count TFAR_setting_defaultFrequencies_sr_east) > 0)): {
			_freq = parseNumber ((TFAR_setting_defaultFrequencies_sr_east splitString ",") select _channel);
		};
		case ((side _group == independent) AND ((count TFAR_setting_defaultFrequencies_sr_independent) > 0)): {
			_freq = parseNumber ((TFAR_setting_defaultFrequencies_sr_independent splitString ",") select _channel);
		};
	};
	
	// Get the name of the group leader
	private _leaderName = if (!isNull (leader _group)) then {
		name (leader _group)
	} else {
		"N/A"
	};
	
	// Create the marker
	private _markerPos = [_startPos # 0, (_startPos # 1) - (_posDiff * _forEachIndex)];
	private _marker = createMarker [format ["xpt_radioMarker_%1",_group], _markerPos];
	_marker setMarkerType "mil_dot";
	_marker setMarkerColor _colour;
	_marker setMarkerText format ["%1 (%2) | Ch %3 | Freq %4", _groupName, _leaderName, _channel + 1, _freq];
} forEach _groupList;