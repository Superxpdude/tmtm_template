/*
	XPT_fnc_headlessSetGroupOwner
	Author: Superxpdude
	Moves groups over to the HC
	
	Parameters:
		0: Group - Group to be transferred
		
	Returns: Nothing
*/

// Only to be run on the server
//if (!isServer) exitWith {_this remoteExec ["XPT_fnc_headlessSetGroupOwner", 2];};

// Define our parameters
//params ["_group"];

// Only send groups over if the HC is connected
//if ((XPT_headless_connected) AND (XPT_headless_clientID != 0)) then {
//	_group setGroupOwner XPT_headless_clientID;
//};

["error", format ["Deprecated function 'XPT_fnc_headlessSetGroupOwner' called from [%1]", _fnc_scriptNameParent], "all"] call XPT_fnc_log;