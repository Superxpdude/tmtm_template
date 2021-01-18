/*
	XPT_fnc_safeStartEnd
	Author: Superxpdude
	Disables the safe start system.
	Must be run on the server.
	
	Parameters:
		None
		
	Returns: Nothing
*/

#include "script_macros.hpp"

if (!isServer) exitWith {};

// Mark the system as disabled
XPT_safeStart_enabled = false;
publicVariable "XPT_safeStart_enabled";

// Run the disable function on all machines
[] remoteExec ["XPT_fnc_safeStartEndLocal",0];