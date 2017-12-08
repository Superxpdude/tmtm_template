/*
	XPT_fnc_radioHandleDeath
	Author: Superxpdude
	Handles assigning radio settings when a player respawns.
	Accounts for any changes a player may have made to their radio settings while they were previously alive.
	
	Parameters:
		Designed to be called directly from onPlayerKilled
		
	Returns: Nothing
*/
// Define variables
_this params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];


// Figure out if the player has radios
private _hasSR = _oldUnit call TFAR_fnc_activeSWRadio;
private _hasLR = _oldUnit call TFAR_fnc_backpackLR;

// If the player has an SR radio. Find the prototype classname and store it.
if (!isNil "_hasSR") then {
	_srRadio = (configfile >> "CfgWeapons" >> _hasSR >> "tf_parent") call BIS_fnc_getCfgData;
	_srSettings = _hasSR call TFAR_fnc_getSWSettings;
	player setVariable ["XPT_savedSRSettings", [_srRadio, _srSettings]];
};

// If the player has an LR radio. Store their radio settings
if (!isNil "_hasLR") then {
	_lrRadio = (backpack _oldUnit);
	_lrSettings = _hasLR call TFAR_fnc_getLRSettings;
	player setVariable ["XPT_savedLRSettings", [_lrRadio, _lrSettings]];
};
