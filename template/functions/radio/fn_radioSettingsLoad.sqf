/*
	XPT_fnc_radioSettingsLoad
	Author: Superxpdude
	Loads previously saved TFAR radio settings for a unit.
	Radio settings are saved locally to the unit itself.
	
	Parameters:
		0: Object - Unit that we want to load settings for.
		
	Returns: Nothing
*/

// Define variables
param ["_unit", nil, [objNull]];

// Exit the script if the unit doesn't exist
if (isNil "_unit") exitWith {};

// Start the loop for SW radios
{
	private ["_radioClass"];

} forEach ([player] call TFAR_fnc_radiosList);