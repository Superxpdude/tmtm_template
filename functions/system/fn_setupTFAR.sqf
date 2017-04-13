// fn_setupTFAR.sqf
// Handles setting up TFAR radios for player units

// Set radio encryption codes
// Mission Type Auto Detection
// Automatically sets up radios depending on the gameType determined in description.ext
private ["_isPVP", "_settingsSW", "_settingsLR", "_settingsSWWest", "_settingsSWEast", "_settingsSWGuer"];
_isPVP = getMissionConfigValue "SXP_isPVP";
if (_isPVP == 1) then {
	tf_west_radio_code = "_tmtm_west";
	tf_east_radio_code = "_tmtm_east";
	tf_guer_radio_code = "_tmtm_guer";
} else {
	tf_west_radio_code = "_tmtm";
	tf_east_radio_code = "_tmtm";
	tf_guer_radio_code = "_tmtm";
};

// TODO: Set radio frequencies to be consistent
TFAR_giveLongRangeRadioToGroupLeaders = false; // Don't automatically give group leaders radio backpacks
TFAR_givePersonalRadioToRegularSoldier = true; // Give regular soldiers good radios instead of terrible rifleman radios
TFAR_SameSRFrequenciesForSide = true; // Use the same short range frequencies for every squad
TFAR_SameLRFrequenciesForSide = true; // Use the same long range frequencies for every squad

// Handles setting radio frequencies
if (isServer) then {
	_settingsSW = false call TFAR_fnc_generateSRSettings;
	_settingsLR = false call TFAR_fnc_generateLRSettings;
	
	// Set frequencies depending on if the mission is PVP or not
	if (_isPVP == 1) then {
		// Set frequencies for BLUFOR
		_settingsSWWest = _settingsSW;
		_settingsSWWest set [2, ["200","220","240","260","280","300","320","340","360"]];
		// Set frequencies for OPFOR
		_settingsSWEast = _settingsSW;
		_settingsSWEast set [2, ["210","230","250","270","290","310","330","350","370"]];
		// Set frequencies for Independent
		_settingsSWGuer = _settingsSW;
		_settingsSWGuer set [2, ["205","215","225","235","245","255","265","275","285"]];
	} else {
		_settingsSW set [2, ["200","220","240","260","280","300","320","340"]];
		_settingsSWWest = _settingsSW;
		_settingsSWEast = _settingsSW;
		_settingsSWGuer = _settingsSW;
	};
	
	_settingsLR set [2, ["50","55","60","65","70","75","80","85","90"]];
	
	TFAR_defaultFrequencies_sr_west = _settingsSWWest;
	TFAR_defaultFrequencies_sr_east = _settingsSWEast;
	TFAR_defaultFrequencies_sr_independent = _settingsSWGuer;
	
	TFAR_defaultFrequencies_lr_west = _settingsLR;
	TFAR_defaultFrequencies_lr_east = _settingsLR;
	TFAR_defaultFrequencies_lr_independent = _settingsLR;
};