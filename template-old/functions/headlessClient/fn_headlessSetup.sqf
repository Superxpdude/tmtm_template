/*
	XPT_fnc_headlessSetup
	Author: Superxpdude
	Handles setting up the headless client framework upon mission start.
	Automatically run on the server when the mission starts.
	
	Parameters: None
		
	Returns: Nothing
*/

// Only to be run on the server
if (!isServer) exitWith {};

// Initialize headless client variables
XPT_headless_clientID = 0;
XPT_headless_connected = false;

// Push the headless client variables to all clients
{
	publicVariable _x;
} forEach ["XPT_headless_clientID", "XPT_headless_connected"];

// Add the event handler for handling HC disconnects
addMissionEventHandler ["PlayerDisconnected", {_this call XPT_fnc_headlessDisconnect;}];