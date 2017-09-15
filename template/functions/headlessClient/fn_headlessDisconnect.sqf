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

// Check if the owner ID matches the ID of the headless client
if (XPT_headless_clientID == _owner) then {
	// Mark the headless client as disconnected
	XPT_headless_connected = false;
	// Clear the stored headless client ID
	XPT_headless_clientID = 0;
	// Push the variables to all clients
	{
		publicVariable _x;
	} forEach ["XPT_headless_clientID", "XPT_headless_connected"];
};