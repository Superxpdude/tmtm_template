// initPlayerLocal.sqf
// Executes on a client machine when they load the mission, regardless of if it's at mission start or JIP.
// _this = [player:Object, didJIP:Boolean]
_this params ["_player", "_jip"];

// Initialise dynamic groups on the player side
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

// Create initial briefings for the players
[] execVM "scripts\briefing.sqf";
[] execVM "scripts\zeusMenu.sqf";

// Add any mission-specific code after this point