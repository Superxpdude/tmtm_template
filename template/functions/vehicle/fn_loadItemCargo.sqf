/*
	XPT_fnc_loadItemCargo
	Author: Superxpdude
	Handles setting up the item cargo of an object/vehicle.
	Reads values from XPTItemsCargos.hpp
	
	Parameters:
		0: Object - Object/vehicle to add items to.
		1: String (Optional) - Config class name to load. Uses the object classname when undefined
		2: Number/Bool (Optional) - Clear existing inventory before applying loadout. 0/false to disable. Defaults to 1/true when undefined.		

	Returns: Bool
		True if the items were added correctly
		False if there was an error
*/

// Define variables
private ["_object", "_loadout", "_class", "_config", "_remove", "_allitems"];
params [
	["_object", nil, [objNull]],
	["_loadout", nil, [""]],
	["_remove", true, [0,false]]
];

if ((typeName _remove) == "SCALAR") then {
	switch (_remove) do {
		case 0: {_remove = false;};
		default {_remove = true;};
	};
};

// Exit the script if the object is undefined.
if (isNil "_object") exitWith {
	[[true,"[XPT-LOADOUT] XPT_fnc_loadItemCargo called with no object defined."]] remoteExec ["XPT_fnc_errorReport", 0];
	false
};

// Find the classname of the object
_class = (typeOf _object);

// Find the config class of the loadout
if (!isNil "_loadout") then {
	_config = ((getMissionConfig "CfgXPT") >> "itemCargos" >> _loadout);
} else {
	_config = ((getMissionConfig "CfgXPT") >> "itemCargos" >> _class);
};

// If the class doesn't exist, return an error
if (!(isClass _config)) exitWith {
	[[true, format ["[XPT-LOADOUT] Missing Item Cargo: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
	false
};

// Check if there are any sub-loadouts for the class
_subclasses = "true" configClasses _class;
if ((count _subclasses) > 0) then {
	// If there are any subclasses, select a random one.
	_class = selectRandom _subclasses;
};

// Retrieve item data from the config files
private ["_items", "_itemsBasicMed", "_itemsAdvMed"];
_items = [((_class >> "items") call BIS_fnc_getCfgData)] param [0, nil, [[]]];
_itemsBasicMed = [((_class >> "itemsBasicMed") call BIS_fnc_getCfgData)] param [0, nil, [[]]];
_itemsAdvMed = [((_class >> "itemsAdvMed") call BIS_fnc_getCfgData)] param [0, nil, [[]]];

// Log errors if definitions are missing. Define the variable as an empty array to prevent further errors
if (isNil "_items") then {
	// Log this one as a critical error, as all loadout definitions need a base items listing
	[[true, format ["[XPT-LOADOUT] Missing items definition for class: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
	_items = [];
};
if (isNil "_itemsBasicMed") then {
	// Log this one as a minor error, this may not be needed depending on the mission, but it should still be there for consistency.
	[[false, format ["[XPT-LOADOUT] Missing itemsBasicMed definition for class: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
	_itemsBasicMed = [];
};
if (isNil "_itemsAdvMed") then {
	// Log this one as a minor error, this may not be needed depending on the mission, but it should still be there for consistency.
	[[false, format ["[XPT-LOADOUT] Missing itemsAdvMed definition for class: ""%1""", _loadout]]] remoteExec ["XPT_fnc_errorReport", 0];
	_itemsAdvMed = [];
};

// Start processing the object

// Remove all items currently in the object
if (_remove) then 
	clearWeaponCargoGlobal _object;
	clearMagazineCargoGlobal _object;
	clearBackpackCargoGlobal _object;
	clearItemCargoGlobal _object;
};

// Create our array of all items to add
if ((["ace_medical_level", 1] call BIS_fnc_getParamValue) == 1) then {
	_allItems = _items + _itemsBasicMed;
} else {
	_allItems = _items + _itemsAdvMed;
};

// Add the items
{
	private ["_count"];
	// Check if the amount value is an array
	if ((typeName (_x select 1)) == "ARRAY") then {
		// Pick a random value for the amount
		_count = random (_x select 1);
	} else {
		_count = (_x select 1);
	};
	_object addItemCargoGlobal [_x select 0,_count];
} forEach _allItems;

// Return true if it completed successfully
true