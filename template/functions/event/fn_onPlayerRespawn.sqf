/*
	XPT_fnc_onPlayerRespawn
	Author: Superxpdude
	Handles template specific entries in onPlayerRespawn
	
	Parameters:
		Designed to be called directly from onPlayerRespawn.sqf
		
	Returns: Nothing
*/

// Define parameters
params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Check if the player needs a loadout assigned
if ((getMissionConfigValue "XPT_customLoadouts") == 1) then {
	[_newUnit] call XPT_fnc_loadCurrentInventory;
};

// Make sure the new player unit is editable by all curators. Needs to be run on the server.
[_newUnit] remoteExec ["XPT_fnc_curatorAddUnit", 2];

// Sets the insignia of the unit to the TMTM insignia
[_newUnit, "tmtm"] remoteExec ["BIS_fnc_setUnitInsignia", 0, true];

// Load the player's radio settings. (This needs to happen after the inventory is loaded)
[_newUnit] spawn XPT_fnc_radioHandleRespawn;