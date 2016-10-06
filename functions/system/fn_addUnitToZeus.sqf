// fn_addUnitToZeus
// Adds a unit to be editable by all zeus modules in the mission
// Only runs on the server
if (!isServer) exitWith {};
private "_unit";
_unit = _this select 0;
// Adds unit to the editable list for all curator modules.
{
	_x addCuratorEditableObjects [[_unit], true];
} forEach allCurators;