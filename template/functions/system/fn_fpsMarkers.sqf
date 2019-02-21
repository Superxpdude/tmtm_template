/*
	XPT_fnc_fpsMarkers
	Author: Superxpdude
	Creates map markers to indicate server and headless client framerates
	
	Parameters:
		Designed to be called directly from initPlayerLocal.sqf
		
	Returns: Nothing
*/

// Not to be run on player clients
if (hasInterface and !isServer) exitWith {};
private ["_serverMark", "_hcMark"];

// If running on the server, create the markers themselves.
if (isServer) then {
	_serverMark = createMarker ["fpsmarker_server", [250,500]];
	_serverMark setMarkerType "mil_start";
	_serverMark setMarkerSize [0.7, 0.7];
	_serverMark setMarkerColor "ColorBlue";
	_serverMark setMarkerText "Server: Setup";
	
	_hcMark = createMarker ["fpsmarker_hc", [250,250]];
	_hcMark setMarkerType "mil_start";
	_hcMark setMarkerSize [0.7, 0.7];
	
	if (isNil "hc") then {
		_hcMark setMarkerColor "ColorGREY";
		_hcMark setMarkerText "HC: Disconnected";
	} else {
		_hcMark setMarkerColor "ColorBlue";
		_hcMark setMarkerText "HC: Setup";
	};
};

// Spawn the loop (since it needs to run forever)

[] spawn {
	private ["_marker", "_name", "_fps"];
	// Make sure we're editing the correct marker
	if (isServer) then {
		_marker = "fpsmarker_server";
		_name = "Server";
	} else {
		_marker = "fpsmarker_hc";
		_name = "HC";
	};
	
	// Wait until the mission has started
	sleep 1;
	
	while {true} do {
		_fps = diag_fps;
		_marker setMarkerColor "ColorGREEN";
		if (_fps <= 30) then {_marker setMarkerColor "ColorYELLOW";};
		if (_fps <= 20) then {_marker setMarkerColor "ColorORANGE";};
		if (_fps <= 10) then {_marker setMarkerColor "ColorRED";};
		
		_marker setMarkerText format ["%1: %2 fps", _name, (round(_fps*100))/100];
		
		// If the HC doesn't exist (will only ever be true on the server), indicate the HC is disconnected
		if (isNil "hc") then {
			"fpsmarker_hc" setMarkerColor "ColorGREY";
			"fpsmarker_hc" setMarkerText "HC: Disconnected";
		};
		
		// Wait 15 seconds between updates
		sleep 15;
	};
};