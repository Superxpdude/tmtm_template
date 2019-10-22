/*
	XPT_fnc_radioHandleRespawn
	Author: Superxpdude
	Handles assigning radios when a player respawns.
	Accounts for any changes a player may have made to their radio settings while they were previously alive.
	
	Parameters:
		0: Object - Unit that respawned. Defaults to player if undefined.
		
	Returns: Nothing
*/
// Do not run before acre has initialized
waitUntil {call acre_api_fnc_isInitialized};

// Exit if the function is run on a machine that does not have a player
if (!hasInterface) exitWith {};

// Define variables
_unit = _this param [0, player, [objNull]];
// Don't run on Zeus units
if (_unit isKindOf "VirtualMan_F") exitWith {};

// Remove the 343
if (!isNil {["ACRE_PRC343"] call acre_api_fnc_getRadioByType}) then {
	_unit removeItem (["ACRE_PRC343"] call acre_api_fnc_getRadioByType);
};

// Add the 148
if (isNil {["ACRE_PRC148"] call acre_api_fnc_getRadioByType}) then {
	_unit addItem "ACRE_PRC148";
};

// Add the 117
if (((leader group _unit) == _unit) AND (isNil {["ACRE_PRC117F"] call acre_api_fnc_getRadioByType})) then {
	if (backpack _unit == "") then {
		_unit addBackpackGlobal "B_AssaultPack_khk";
	};
	_unit addItem "ACRE_PRC117F";
};