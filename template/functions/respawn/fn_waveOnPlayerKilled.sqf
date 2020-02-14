/*
	XPT_fnc_waveOnPlayerKilled
	Author: Superxpdude
	onPlayerKilled portion of the XPT_waves respawn template
	
	Parameters: None
	
	Returns: Nothing
*/

#include "script_macros.hpp"

// Define parameters
params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

private _startTime = missionNamespace getVariable ["XPT_respawn_wave_startTime",-1];

// If we don't have a start time defined, we need to set one
if (_startTime < 0) then {
	_startTime = serverTime;
	missionNamespace setVariable ["XPT_respawn_wave_startTime",_startTime,true];
};

private _currentTime = serverTime;
private _respawnDelay = getMissionConfigValue ["respawnDelay",180];
private _respawnTimer = _respawnDelay - ((_currentTime - _serverTime) mod _respawnDelay);

setPlayerRespawnTime _respawnTimer;