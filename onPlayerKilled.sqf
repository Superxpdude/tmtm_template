// onPlayerKilled.sqf
// Executes on a player's machine when they die
// _this = [<oldUnit>, <killer>, <respawn>, <respawnDelay>]
_this params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Call the template onPlayerKilled function
_this call XPT_fnc_onPlayerKilled; // DO NOT CHANGE THIS LINE

// Add any mission specific code after this point
