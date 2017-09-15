/*
	XPT_fnc_headlessDisconnect
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

// Register the clientID of the headless client, and enable the headless client
XPT_headless_clientID = owner _player;
XPT_headless_connected = true;

// Push the headless client variables to all clients
{
	publicVariable _x;
} forEach ["XPT_headless_clientID", "XPT_headless_connected"];

// Move all existing non-player groups over to the headless client
{
	if (!(isPlayer (leader _x))) then {
		[_x] call XPT_fnc_headlessSetGroupOwner;
	};
} forEach allGroups;

// Return nothing
nil
