/*
	XPT_fnc_radioSettingsSave
	Author: Superxpdude
	Saves TFAR radio settings of the player in order to load them at a later time.
	This is purely client-side. As of this time I see no need to sync these settings across the network.
	
	Saves the following radio settings:
	
	Parameters:
		None
		
	Returns: Nothing
*/

// No need to run this on a machine that's not a player.
if (!hasInterface) exitWith {};

// Start the loop for SW radios
{
	private ["_radioClass"];
	if ([_x] call TFAR_fnc_isPrototypeRadio) then {
		// If the radio is a prototype, take the classname directly
		_radioClass = _x;
	} else {
		// If the radio is not a prototype. Grab the classname of the prototype radio.
		_radioClass = configName (inheritsFrom (configFile >> "CfgWeapons" >> _x))
	player setVariable [format ["radioSettings_%1", _radioClass], [_x] call TFAR_fnc_getSwSettings];
} forEach ([player] call TFAR_fnc_radiosList);

// Grab the player's current LR settings. The following will return nil if no LR is present
private _LRsettings = (player call TFAR_fnc_backpackLR) call TFAR_fnc_getLrSettings;
// If the player has a LR radio, save their settings.
if (!isNil "_LRsettings") then {
	player setVariable [format ["radioSettings_%1", backpack player], _LRsettings];
};

// Return nothing
nil
