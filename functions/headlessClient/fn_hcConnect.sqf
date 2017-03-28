// Function to handle registering the headless client
// Called from initPlayerServer.sqf when a client connects to the server

// Only to be run on the server
if (!isServer) exitWith {};

// Don't run if the headless client is disabled in mission parameters
if ((["headlessClient", 0] call BIS_fnc_getParamValue) == 0) exitWith {};

// Define our variables
_this params ["_player", "_jip"];

// Register the clientID of the headless client
sxp_hc_clientID = owner _player;

// Mark the headless client as active
sxp_hc_enabled = true;

// Move all existing non-player groups over to the headless client
{
	if (!(isPlayer (leader _x))) then {
		[_x] call SXP_fnc_hcSetGroupOwner;
	};
} forEach allGroups;