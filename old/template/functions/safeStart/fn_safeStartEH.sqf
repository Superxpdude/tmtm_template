/*
	XPT_fnc_safeStartEH
	Author: Superxpdude
	Event handler execution for the safeStart system.
	Called on "ace_firedPlayer" and "ace_firedPlayerVehicle" CBA events.
	
	Parameters:
		0: Array - "ace_firedPlayer(vehicle)" arguments
		1: Number - CBA event handler ID
		2: String - Type of CBA event
		
	Returns: Nothing
*/

#include "script_macros.hpp"

params ["_args","_id","_type"];
_args params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

// Check if safe start is still active
if (missionNamespace getVariable ["XPT_safeStart_enabled",true]) then {
	hintSilent "Safe start active. Weapons are disabled.";
	deleteVehicle _projectile;
} else {
	// Safe start disabled. Remove the event handler (safe start shouldn't be re-enabled mid-mission.
	[_type,_id] call CBA_fnc_removeEventHandler;
	[2,format ["Removing safe start event handler using failsafe: [%1|%2]", _type, _id],0] call XPT_fnc_log;
};