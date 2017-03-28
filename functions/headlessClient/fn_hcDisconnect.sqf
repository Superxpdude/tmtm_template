// Function to handle a disconnection of the headless client
// Written to be called from a PlayerDisconnected mission event handler
_this params ["_id", "_uid", "_name", "_jip", "_owner"];

// Only to be run on the server
if (!isServer) exitWith {};

// Check if the ownerID of the disconnecting player matches the ID of the registered headless client
if (sxp_hc_clientID == _owner) then {
	// Mark the headless client as disabled
	sxp_hc_enabled = false;
	// Change the clientID of the headless client to 0
	sxp_hc_clientID = 0;
	// Push these variables to all clients
	{
		publicVariable _x;
	} forEach ["sxp_hc_enabled", "sxp_hc_clientID"];
};	