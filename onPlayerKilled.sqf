// onPlayerKilled.sqf
// Executes on a player's machine when they die
// _this = [<oldUnit>, <killer>, <respawn>, <respawnDelay>]

[_this select 0] call SXP_fnc_saveRadioSettings;

