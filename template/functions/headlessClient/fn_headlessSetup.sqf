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

// Initialize the clientID array and push it to all clients
XPT_headless_clientIDs = [-1, -1, -1];
publicVariable "XPT_headless_clientIDs";

// Add the event handler for handling HC disconnects
addMissionEventHandler ["PlayerDisconnected", {_this call XPT_fnc_headlessDisconnect;}];