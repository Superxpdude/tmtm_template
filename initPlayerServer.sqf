// initPlayerServer.sqf
// Runs once on the server for each player that joins the game.
// This will run multiple times at mission start if multiple players are present
// _this = [player:Object, didJIP:Boolean]
_this params ["_player", "_jip"];

if (_player isKindOf "HeadlessClient_F") then {
	_this call SXP_fnc_hcConnect;
};

// Add any mission specific code after this point