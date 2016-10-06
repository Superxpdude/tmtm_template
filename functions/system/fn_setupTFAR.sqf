// fn_setupTFAR.sqf
// Handles setting up TFAR radios for player units

// Set radio encryption codes
// Use these for COOP missions, this sets all radios to the same encryption
// Comment this out for TvTs
tf_west_radio_code = "_tmtm";
tf_east_radio_code = "_tmtm";
tf_guer_radio_code = "_tmtm";

// TODO: Set radio frequencies to be consistent
tf_no_auto_long_range_radio = true; // Don't automatically give group leaders radio backpacks
tf_give_personal_radio_to_regular_soldier = true; // Give regular soldiers good radios instead of terrible rifleman radios
tf_same_sw_frequencies_for_side = true; // Use the same short range frequencies for every squad
tf_same_lr_frequencies_for_side = true; // Use the same long range frequencies for every squad

// Handles setting radio frequencies
if (isServer) then {
	_settingsSW = false call TFAR_fnc_generateSwSettings;
	_settingsLR = false call TFAR_fnc_generateLRSettings;
	
	_settingsSW set [2, ["200","225","250","275","300","325","350","375"]];
	_settingsLR set [2, ["50","55","60","65","70","75","80","85","90"]];
	
	tf_freq_west = _settingsSW;
	tf_freq_east = _settingsSW;
	tf_freq_guer = _settingsSW;
	
	tf_freq_west_lr = _settingsLR;
	tf_freq_east_lr = _settingsLR;
	tf_freq_guer_lr = _settingsLR;
};