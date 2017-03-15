// fn_saveRadioSettings.sqf
// Handles saving the radio classnames of a unit when they die.
// Used with SXP_fnc_loadRadioSettings to copy the player's radio settings to their new radios.

// Save the current SW radio
missionNamespace setVariable [format ["%1_SW", getPlayerUID player], [] call TFAR_fnc_activeSwRadio];
// Save the current LR radio
missionNamespace setVariable [format ["%1_LR", getPlayerUID player], [] call TFAR_fnc_activeLrRadio];
