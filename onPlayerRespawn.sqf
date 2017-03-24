// onPlayerRespawn.sqf
// Executes on a player's machine when they respawn
// _this = [<newUnit>, <oldUnit>, <respawn>, <respawnDelay>]
_this params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if ((getMissionConfigValue "SXP_customLoadouts") == 1) then {
	// Handle giving units their proper loadouts upon respawn.
	// If the variable "loadout" is given to a unit, that loadout will be used from CfgRespawnInventory
	// If the variable is not used, the classname of the unit will be used.
	_loadout = _newUnit getVariable ["loadout", "config"];
	if (_loadout == "config") then {
		_loadout = typeOf _newUnit;
	};
	
	// Check where the loadout is located, and execute the corresponding script
	switch true do {
		case (isClass ((getMissionConfig "CfgSuperXP") >> "loadouts" >> _loadout)): {[_newUnit, (getMissionConfig "CfgSuperXP") >> "loadouts" >> _loadout] call SXP_fnc_loadInventory;};
		case (isClass ((getMissionConfig "CfgRespawnInventory") >> _loadout)): {[_newUnit, (getMissionConfig "CfgRespawnInventory") >> _loadout] call BIS_fnc_loadInventory;};
	};
};

// Makes sure the unit is editable by all zeus modules. Needs to be run on the server
[_newUnit] remoteExec ["SXP_fnc_addUnitToZeus", 2];

// Sets the insignia of the unit to the TMTM insignia
[_newUnit, "tmtm"] remoteExec ["BIS_fnc_setUnitInsignia", 0, true];

// Add any mission specific code after this point