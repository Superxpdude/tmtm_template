/*
	XPT_fnc_headlessDisconnect
	Author: Superxpdude
	Handles a headless client that disconnects mid-mission
	
	Parameters:
		Designed to be called from a PlayerDisconnected mission event handler
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Define variables
_this params ["_id", "_uid", "_name", "_jip", "_owner"];

// Check and see if the owner ID is present in the headless client array
if (_owner in XPT_headless_clientIDs) then {
	// Grab the index of the ID
	private _index = XPT_headless_clientIDs findIf {_x == _owner};
	// Delete the ID
	XPT_headless_clientIDs set [_index, -1];
	// Update the array of all clients
	publicVariable "XPT_headless_clientIDs";
};