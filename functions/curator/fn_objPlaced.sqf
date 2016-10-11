// SXP_fnc_objPlaced
// Called from a CuratorObjectPlaced eventhandler
// Sets any unit placed by a zeus module to be editable by all other modules

private ["_curator", "_placed"];
_curator = _this select 0;
_placed = _this select 1;

// Add the unit to be editable by all zeus modules
{
	_x addCuratorEditableObjects [[_placed], true];
} forEach (allCurators - [_curator]);

nil 