/*
	XPT_fnc_fpsMarkers
	Author: Superxpdude
	Creates map markers to indicate server and headless client framerates, and unit counts
	
	Parameters:
		Designed to be called in postInit.
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Not to be run on player clients
if (hasInterface and !isServer) exitWith {};
private ["_serverMark", "_hcMark", "_hcMark2", "_hcMark3"];

private _markerSpacing = 250;

[3, "Initializing FPS markers", 0] call XPT_fnc_log;

// If running on the server, create the markers themselves.
if (isServer) then {
	_serverMark = createMarker ["fpsmarker_server", [250,_markerSpacing * 4]];
	_serverMark setMarkerType "mil_start";
	_serverMark setMarkerSize [0.7, 0.7];
	_serverMark setMarkerColor "ColorBlue";
	_serverMark setMarkerText "Server: Setup";
	
	_hcMark = createMarker ["fpsmarker_hc", [250,_markerSpacing * 3]];
	_hcMark setMarkerType "mil_start";
	_hcMark setMarkerSize [0.7, 0.7];
	
	_hcMark2 = createMarker ["fpsmarker_hc2", [250,_markerSpacing * 2]];
	_hcMark2 setMarkerType "mil_start";
	_hcMark2 setMarkerSize [0.7, 0.7];
	
	_hcMark3 = createMarker ["fpsmarker_hc3", [250,_markerSpacing * 1]];
	_hcMark3 setMarkerType "mil_start";
	_hcMark3 setMarkerSize [0.7, 0.7];
	
	if (isNil "hc") then {
		_hcMark setMarkerColor "ColorGREY";
		_hcMark setMarkerText "HC: Disconnected";
	} else {
		_hcMark setMarkerColor "ColorBlue";
		_hcMark setMarkerText "HC: Setup";
	};
	if (isNil "hc2") then {
		_hcMark2 setMarkerColor "ColorGREY";
		_hcMark2 setMarkerText "HC2: Disconnected";
	} else {
		_hcMark2 setMarkerColor "ColorBlue";
		_hcMark2 setMarkerText "HC2: Setup";
	};
	if (isNil "hc3") then {
		_hcMark3 setMarkerColor "ColorGREY";
		_hcMark3 setMarkerText "HC3: Disconnected";
	} else {
		_hcMark3 setMarkerColor "ColorBlue";
		_hcMark3 setMarkerText "HC3: Setup";
	};
	
	[3, "FPS markers created", 0] call XPT_fnc_log;
};

// Spawn the loop (since it needs to run forever)

[] spawn {
	private ["_marker", "_name", "_fps"];
	// Make sure we're editing the correct marker
	switch (true) do {
		case (isServer): {
			_marker = "fpsmarker_server";
			_name = "Server";
		};
		case ((vehicleVarName player) == "HC"): {
			_marker = "fpsmarker_hc";
			_name = "HC1";
		};
		case ((vehicleVarName player) == "HC2"): {
			_marker = "fpsmarker_hc2";
			_name = "HC2";
		};
		case ((vehicleVarName player) == "HC3"): {
			_marker = "fpsmarker_hc3";
			_name = "HC3";
		};
	};
	
	[3, format ["Starting FPS markers loop on [%1]",_name], 1] call XPT_fnc_log;
	
	// Wait until the mission has started
	sleep 1;
	
	while {true} do {
		_fps = diag_fps;
		_marker setMarkerColor "ColorGREEN";
		if (_fps <= 30) then {_marker setMarkerColor "ColorYELLOW";};
		if (_fps <= 20) then {_marker setMarkerColor "ColorORANGE";};
		if (_fps <= 10) then {_marker setMarkerColor "ColorRED";};
		
		_marker setMarkerText format ["%1: %2 fps | %3 units", _name, (round(_fps*100))/100, {local _x} count allUnits];
		
		if (isServer) then {
			// If the HC doesn't exist (will only ever be true on the server), indicate the HC is disconnected
			if (isNil "hc") then {
				"fpsmarker_hc" setMarkerColor "ColorGREY";
				"fpsmarker_hc" setMarkerText "HC: Disconnected";
			};
			if (isNil "hc2") then {
				"fpsmarker_hc2" setMarkerColor "ColorGREY";
				"fpsmarker_hc2" setMarkerText "HC: Disconnected";
			};
			if (isNil "hc3") then {
				"fpsmarker_hc3" setMarkerColor "ColorGREY";
				"fpsmarker_hc3" setMarkerText "HC: Disconnected";
			};
		};
		
		// Wait 15 seconds between updates
		sleep 15;
	};
};