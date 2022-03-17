/*
	XPT_fnc_jipTeleport
	Author: blah2355
	Attempts to teleport JIP players to their respective squads. Called by Communication Menu.
	
	Parameters:
		0: Object - Player unit
		
	Returns: Nothing
*/

params ["_player"];

private _grp = group _player;
private _sl = leader _grp;
private _moved = false;

private _fn_teleportFoot = {
	private _fn_player = _this select 0;
	private _fn_target = _this select 1;
	[
		{preloadCamera getPosATL (_this select 0)},
		{
			[_this select 0, _this select 1] spawn {
				call BIS_fnc_VRFadeOut;
				sleep 2;
				(_this select 0) setPosATL ((_this select 1) getRelPos [3, selectRandom [135,225]]);
				call BIS_fnc_VRFadeIn;
			};
		},
		[_fn_player, _fn_target],
		5,
		{(_this select 0) setPosATL ((_this select 1) getRelPos [3, selectRandom [135,225]]);}
	] call CBA_fnc_waitUntilAndExecute;
};

private _fn_teleportVeh = {
	private _fn_player = _this select 0;
	private _fn_target = _this select 1;
	private _return = false;
	//call BIS_fnc_VRFadeOut;
	//_fn_player moveInAny (vehicle _fn_target);
	private _vehicleEmptyPositions = 0;
	{
		_vehicleEmptyPositions = _vehicleEmptyPositions + ((vehicle _fn_target) emptyPositions _x);
	} forEach ["cargo", "driver", "commander", "gunner"];
	
	if (_vehicleEmptyPositions > 0) then {
		[
			{preloadCamera getPosATL (_this select 0)},
			{
				[_this select 0, _this select 1] spawn {
					call BIS_fnc_VRFadeOut;
					sleep 2;
					(_this select 0) moveInAny (vehicle (_this select 1));
					call BIS_fnc_VRFadeIn;
				};
			},
			[_fn_player, _fn_target],
			5,
			{(_this select 0) moveInAny (vehicle (_this select 1));}
		] call CBA_fnc_waitUntilAndExecute;
		_return = true
	};
	_return
};

// Try to teleport to squad leader first only if the player is not also the squad lead
if (player != _sl) then {
	if (alive _sl && vehicle _sl == _sl && (_player distance _sl > 100)) exitWith {[_player, _sl] call _fn_teleportFoot};
	// If above fails, check if squad leader is in a vehicle
	if (alive _sl && vehicle _sl != _sl) then {_moved = [_player, _sl] call _fn_teleportVeh};
	if (_moved) exitWith {};
};

// Player has not already been moved
if (!_moved) then {
	// Resort to teleporting to other members of the squad
	_squad = (units _grp) - [_sl];
	0 = {
			if (alive _x && (_player distance _x > 100) && vehicle _x == _x) exitWith {[_player, _x] call _fn_teleportFoot};
			if (alive _x && vehicle _x != _x) then {_moved = [_player, _X] call _fn_teleportVeh};
			if (_moved) exitWith {};
	} forEach (_squad);
};

if (!_moved) then {["XPT_jipTeleFail", []] call BIS_fnc_showNotification};