// Function to transfer group ownership to another machine
// Only to be run on the server
if (!isServer) exitWith {_this remoteExec ["SXP_fnc_hcSetGroupOwner", 2];};

// Define our parameters
_this params ["_group"];

// Only send the groups over if the hc is enabled and registered
if (sxp_hc_enabled && (sxp_hc_clientID != 0)) then {
	// Send the groups directly to the registered headless client group ID
	_group setGroupOwner sxp_hc_clientID;
};