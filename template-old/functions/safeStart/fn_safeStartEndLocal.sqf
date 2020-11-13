/*
	XPT_fnc_safeStartEndLocal
	Author: Superxpdude
	Disables the safe start system for the local player.
	
	Parameters:
		None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

private _playerEH = player getVariable "XPT_safeStartPlayerEH";
private _vehicleEH = player getVariable "XPT_safeStartVehicleEH";
if (!isNil "_playerEH") then {
	["ace_firedPlayer",_playerEH] call CBA_fnc_removeEventHandler;
	[3,format ["Removing safe start event handler: ['ace_firedPlayer'|%1]", _playerEH],0] call XPT_fnc_log;
};
if (!isNil "_vehicleEH") then {
	["ace_firedPlayerVehicle",_vehicleEH] call CBA_fnc_removeEventHandler;
	[3,format ["Removing safe start event handler: ['ace_firedPlayerVehicle'|%1]", _vehicleEH],0] call XPT_fnc_log;
};
hintSilent ["Safe start deactivated. Weapons enabled."];