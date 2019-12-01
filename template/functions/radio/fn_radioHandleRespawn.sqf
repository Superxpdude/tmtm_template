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
if ((_unit isKindOf "VirtualMan_F") or (_unit getVariable ["XPT_zeusUnit", false])) exitWith {};

if ((getMissionConfigValue "XPT_acre_autoradio") == 1) then {
	// Autoradio will automatically provide squad leaders with AN/PRC-152s
	// Remove the 343
	//if (!isNil {["ACRE_PRC343"] call acre_api_fnc_getRadioByType}) then {
	//	_unit removeItem (["ACRE_PRC343"] call acre_api_fnc_getRadioByType);
	//};
	// If the player does not have one, try to add an AN/PRC-343
	if ((isNil {["ACRE_PRC343"] call acre_api_fnc_getRadioByType}) AND !("ACRE_PRC343" in items _unit)) then {
		_unit addItem "ACRE_PRC343";
		// Check if the radio was added successfully
		if ((isNil {["ACRE_PRC343"] call acre_api_fnc_getRadioByType}) AND !("ACRE_PRC343" in items _unit)) then {
			[true, format ["Autoradio was unable to provide an AN/PRC343. Type: '%1' Unit: '%2'", typeOf _unit, name _unit], 2] call XPT_fnc_error;
		};
	};
	

	// If the player is the leader of their squad, try to add a 152.
	if (((leader group _unit) == _unit) AND (isNil {["ACRE_PRC152"] call acre_api_fnc_getRadioByType}) AND !("ACRE_PRC152" in items _unit)) then {
		_unit addItem "ACRE_PRC152";
		// Check if the radio was added successfully
		if ((isNil {["ACRE_PRC152"] call acre_api_fnc_getRadioByType}) AND !("ACRE_PRC152" in items _unit)) then {
			[true, format ["Autoradio was unable to provide an AN/PRC152. Type: '%1' Unit: '%2'", typeOf _unit, name _unit], 2] call XPT_fnc_error;
		};
	};
};

[{
    call acre_api_fnc_isInitialized
}, {
	_unit = _this select 0;
	// Grab a list of all acre radios
	_radios = [] call acre_api_fnc_getCurrentRadioList;
	// Get the radio channels
	private _channel_343 = (_unit getVariable ["XPT_ACRE_channel_343", ((group _unit) getVariable ["XPT_ACRE_channel_343", -1])]);
	private _channel_148 = (_unit getVariable ["XPT_ACRE_channel_148", ((group _unit) getVariable ["XPT_ACRE_channel_148", -1])]);
	private _channel_152 = (_unit getVariable ["XPT_ACRE_channel_152", ((group _unit) getVariable ["XPT_ACRE_channel_152", -1])]);
	private _channel_117 = (_unit getVariable ["XPT_ACRE_channel_117", ((group _unit) getVariable ["XPT_ACRE_channel_117", -1])]);
	//private _channel_77 = (_unit getVariable ["XPT_ACRE_channel_77", ((group _unit) getVariable ["XPT_ACRE_channel_77", -1])]); // ACRE_PRC77
	private _channel_sem52 = (_unit getVariable ["XPT_ACRE_channel_sem52", ((group _unit) getVariable ["XPT_ACRE_channel_sem52", -1])]);
	//private _channel_sem70 = (_unit getVariable ["XPT_ACRE_channel_sem70", ((group _unit) getVariable ["XPT_ACRE_channel_sem70", -1])]); // ACRE_SEM70
	
	// Iterate through all radios, and set their default channels
	{
		switch (toUpper ([_x] call acre_api_fnc_getBaseRadio)) do {
			case "ACRE_PRC343": {
				if (_channel_343 >= 0) then {
					[_x,_channel_343] call acre_api_fnc_setRadioChannel;
				};
				[_x, _unit getVariable ["XPT_ACRE_spatial_343", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_PRC148": {
				if (_channel_148 >= 0) then {
					[_x,_channel_148] call acre_api_fnc_setRadioChannel;
				};
				[_x, _unit getVariable ["XPT_ACRE_spatial_148", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_PRC152": {
				if (_channel_152 >= 0) then {
					[_x,_channel_152] call acre_api_fnc_setRadioChannel;
				};
				[_x, _unit getVariable ["XPT_ACRE_spatial_152", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_PRC117F": {
				if (_channel_117 >= 0) then {
					[_x,_channel_117] call acre_api_fnc_setRadioChannel;
				};
				[_x, _unit getVariable ["XPT_ACRE_spatial_117", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_SEM52SL": {
				if (_channel_sem52 >= 0) then {
					[_x,_channel_sem52] call acre_api_fnc_setRadioChannel;
				};
				[_x, _unit getVariable ["XPT_ACRE_spatial_sem52", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_PRC77": {
				[_x, _unit getVariable ["XPT_ACRE_spatial_77", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			case "ACRE_SEM70": {
				[_x, _unit getVariable ["XPT_ACRE_spatial_sem70", "CENTER"]] call acre_api_fnc_setRadioSpatial
			};
			default {} // Do nothing for other radios
		};
	} forEach _radios;
	
	// Set the push-to-talk assignments
	private _ptt = [];
	{
		_radio = [_x] call acre_api_fnc_getRadioByType;
		if (!isNil "_radio") then {
			_ptt append [_radio];
		};
	} forEach (_unit getVariable ["XPT_ACRE_ptt",[]]);
	[_ptt] call acre_api_fnc_setMultiPushToTalkAssignment;
	
}, _this] call CBA_fnc_waitUntilAndExecute;