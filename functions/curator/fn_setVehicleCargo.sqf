// fn_setVehicleCargo
// Clears the cargo of a vehicle, and provides it with custom equipment
// Intended to be called from a CuratorObjectPlaced eventhandler
_unit = _this select 1;

// End the script if the unit is a man.
if (_unit isKindOf "Man") exitWith {};

