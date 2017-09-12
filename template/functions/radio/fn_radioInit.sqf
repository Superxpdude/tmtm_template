/*
	XPT_fnc_radioInit
	Author: Superxpdude
	Handles setting up radio settings.
	
	Parameters: None
		
	Returns: Nothing
*/

// Define variables
private ["_isPVP", "_settingsSW", "_settingsLR", "_settingsSWWest", "_settingsSWEast", "_settingsSWGuer"];

// Check if the mission is a PVP mission
_isPVP = getMissionConfigValue "XPT_isPVP";
if (_isPVP == 1) then {
	tf_west_radio_code = "_radio_west";
	tf_east_radio_code = "_radio_east";
	tf_guer_radio_code = "_radio_guer";
} else {
	tf_west_radio_code = "_radio";
	tf_east_radio_code = "_radio";
	tf_guer_radio_code = "_radio";
};

// TODO: Set radio frequencies to be consistent
TFAR_giveLongRangeRadioToGroupLeaders = false; // Don't automatically give group leaders radio backpacks
TFAR_givePersonalRadioToRegularSoldier = true; // Give regular soldiers good radios instead of terrible rifleman radios
TFAR_SameSRFrequenciesForSide = true; // Use the same short range frequencies for every squad
TFAR_SameLRFrequenciesForSide = true; // Use the same long range frequencies for every squad

// Handles setting radio frequencies
if (isServer) then {
	// Set frequencies depending on if the mission is PVP or not
	if (_isPVP == 1) then {
		// Set frequencies for BLUFOR
		_settingsSWWest = ["100","110","120","130","140","150","160","170","180"];
		// Set frequencies for OPFOR
		_settingsSWEast = ["200","210","220","230","240","250","260","270","280"];
		// Set frequencies for Independent
		_settingsSWGuer = ["300","310","320","330","340","350","360","370","380"];
	} else {
		_settingsSW = ["100","110","120","130","140","150","160","170","180"];
		_settingsSWWest = _settingsSW;
		_settingsSWEast = _settingsSW;
		_settingsSWGuer = _settingsSW;
	};
	
	_settingsLR = ["50","55","60","65","70","75","80","85","90"];
	
	TFAR_defaultFrequencies_sr_west = _settingsSWWest;
	TFAR_defaultFrequencies_sr_east = _settingsSWEast;
	TFAR_defaultFrequencies_sr_independent = _settingsSWGuer;
	
	TFAR_defaultFrequencies_lr_west = _settingsLR;
	TFAR_defaultFrequencies_lr_east = _settingsLR;
	TFAR_defaultFrequencies_lr_independent = _settingsLR;
};