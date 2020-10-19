// onPlayerRespawn.sqf
// Executes on a player's machine when they respawn
// _this = [<newUnit>, <oldUnit>, <respawn>, <respawnDelay>]
_this params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Call the template onPlayerRespawn function
_this call XPT_fnc_onPlayerRespawn; // DO NOT CHANGE THIS LINE

// Add any mission specific code after this point