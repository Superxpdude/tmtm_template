// SXP_fnc_grpPlaced
// Called from a CuratorGroupPlaced eventhandler
// Sets any group placed by a zeus module to be editable by all other modules

private ["_curator", "_placed"];
_curator = _this select 0;
_placed = _this select 1;

// Add the unit to be editable by all zeus modules
{
	_x addCuratorEditableObjects [(units _placed), true];
} forEach (allCurators - [_curator]);

nil 