/*
	XPT_fnc_headlessConnect
	Author: Superxpdude
	Handles setting up a headless client
	
	Parameters:
		Designed to be called from a initPlayerServer.sqf
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Define variables
params ["_player", "_jip"];

// Only run the script if the client is headless
if (!(_player isKindOf "HeadlessClient_F")) exitWith {};

// Grab the client ID of the headless client
private _clientID = owner _player;

// Add the client ID to the headless client array
private _index = XPT_headless_clientIDs findIf {_x == -1};
// If we can't find an empty spot. Log an error
if (_index < 0) exitWith {
	["warning", format ["Headless client joined with no available space in XPT array. %1", XPT_headless_clientIDs], "local"] call XPT_fnc_log;
};

// Broadcast the clientID array to all clients
XPT_headless_clientIDs set [_index,_clientID];
publicVariable "XPT_headless_clientIDs";

// Return nothing
nil