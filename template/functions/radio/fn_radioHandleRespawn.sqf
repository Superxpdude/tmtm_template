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

if ((getMissionConfigValue "XPT_acre_autoradio") == 1) then {
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
};


[{
    call acre_api_fnc_isInitialized
}, {
	_unit = _this select 0;
	// Set radio channels
	private _channel_343 = (_unit getVariable ["ACRE_channel_343", ((group _unit) getVariable ["ACRE_channel_343", -1])]);
	private _channel_148 = (_unit getVariable ["ACRE_channel_148", ((group _unit) getVariable ["ACRE_channel_148", -1])]);
	private _channel_152 = (_unit getVariable ["ACRE_channel_152", ((group _unit) getVariable ["ACRE_channel_152", -1])]);
	private _channel_117 = (_unit getVariable ["ACRE_channel_117", ((group _unit) getVariable ["ACRE_channel_117", -1])]);
	//private _channel_77 = (_unit getVariable ["ACRE_channel_77", ((group _unit) getVariable ["ACRE_channel_77", -1])]);
	private _channel_sem52 = (_unit getVariable ["ACRE_channel_sem52", ((group _unit) getVariable ["ACRE_channel_sem52", -1])]);
	//private _channel_sem70 = (_unit getVariable ["ACRE_channel_sem70", ((group _unit) getVariable ["ACRE_channel_sem70", -1])]);

	if (_channel_343 >= 0) then {
		[["ACRE_PRC343"] call acre_api_fnc_getRadioByType, _channel_343] call acre_api_fnc_setRadioChannel;
	};

	if (_channel_148 >= 0) then {
		[["ACRE_PRC148"] call acre_api_fnc_getRadioByType, _channel_148] call acre_api_fnc_setRadioChannel;
	};

	if (_channel_152 >= 0) then {
		[["ACRE_PRC152"] call acre_api_fnc_getRadioByType, _channel_152] call acre_api_fnc_setRadioChannel;
	};

	if (_channel_117 >= 0) then {
		[["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, _channel_117] call acre_api_fnc_setRadioChannel;
	};

//	if (_channel_77 >= 0) then {
//		[["ACRE_PRC77"] call acre_api_fnc_getRadioByType, _channel_77] call acre_api_fnc_setRadioChannel;
//	};

	if (_channel_sem52 >= 0) then {
		[["ACRE_SEM52SL"] call acre_api_fnc_getRadioByType, _channel_sem52] call acre_api_fnc_setRadioChannel;
	};

//	if (_channel_sem70 >= 0) then {
//		[["ACRE_SEM70"] call acre_api_fnc_getRadioByType, _channel_sem70] call acre_api_fnc_setRadioChannel;
//	};
}, _this] call CBA_fnc_waitUntilAndExecute;