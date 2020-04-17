/*
	XPT_fnc_onPlayerRespawn
	Author: Superxpdude
	Handles template specific entries in onPlayerRespawn
	
	Parameters:
		Designed to be called directly from onPlayerRespawn.sqf
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define parameters
params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Re-enable feedback post-processing effects upon respawn
BIS_fnc_feedback_allowPP = true;

// Check if the player needs a loadout assigned
if ((getMissionConfigValue "XPT_customLoadouts") == 1) then {
	[_newUnit] call XPT_fnc_loadCurrentInventory;
};

// Make sure the new player unit is editable by all curators. Needs to be run on the server.
[_newUnit] remoteExec ["XPT_fnc_curatorAddUnit", 2];

// Sets the insignia of the unit to the TMTM insignia
if ((getMissionConfigValue ["XPT_tmtm_insignia",1]) == 1) then {
	[_newUnit, "tmtm"] remoteExec ["BIS_fnc_setUnitInsignia", 0, true];
};

// Load the player's radio settings. (This needs to happen after the inventory is loaded)
if ((getMissionConfigValue "XPT_acre_enable") == 1) then {
	[_newUnit] spawn XPT_fnc_radioHandleRespawn;
};

// If enabled, remove the player from spectator
if ((getMissionConfigValue ["XPT_acre_autospectator",1]) == 1) then {
	[false] call acre_api_fnc_setSpectator;
};

// If the player is a zeus unit. Spawn the movement loop
_zeus = _newUnit getVariable ["XPT_zeusUnit", false];
if !(_zeus isEqualTo false) then {
	_newUnit spawn {
		waitUntil {!isNull (getAssignedCuratorLogic _this)};
		_this allowDamage false;
		// These commands need to be executed on the server
		[_this, false] remoteExec ["enableSimulationGlobal", 2];
		[_this, true] remoteExec ["hideObjectGlobal", 2];
		// Wait until the mission has started
		waitUntil {time > 2};
		// Start the loop
		while {alive _this} do {
			sleep 1;
			_this setPosASL (getPosASL curatorCamera);
			_this setDir (getDir curatorCamera);
		};
	};
};