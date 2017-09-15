/*
	XPT_fnc_errorReport
	Author: Superxpdude
	Handles reporting errors in the appropriate locations.
	Supports creating multiple error messages in multiple locations simultaneuously.
	
	Debug mode can be enabled from the lobby parameters.
	Error messages will always be reported to the RPT.
	However, they will only be reported in-game if they are marked as a critical error, or debug mode is on.
	
	General rule of thumb is critical errors should always be reported both in the RPT and in-game.
	Minor errors should only be reported in-game if debug mode is on.
	
	Parameters:
		0: Array - Error message
			0:0: Bool - True to mark error as critical
			0:1: String - Error message to be reported.
		1: (Optional) Array - Error message
		...
		Same syntax is followed for every array.
		
	Returns: Nothing
*/
private ["_debug"];
_debug = (["XPT_debugMode", 0] call BIS_fnc_getParamValue);

// Report errors
{
	if ((_x select 0) OR (_debug == 1)) then {
		systemChat (_x select 1);
	};
	diag_log (_x select 1);
} forEach _this;
	