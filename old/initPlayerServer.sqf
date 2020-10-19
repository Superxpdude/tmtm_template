// initPlayerServer.sqf
// Runs once on the server for each player that joins the game.
// This will run multiple times at mission start if multiple players are present
// _this = [player:Object, didJIP:Boolean]
params ["_player", "_jip"];

// Call the template initPlayerServer function
_this call XPT_fnc_initPlayerServer; // DO NOT CHANGE THIS LINE

// Add any mission specific code after this point