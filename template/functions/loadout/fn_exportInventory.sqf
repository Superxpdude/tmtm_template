/*
	XPT_fnc_exportInventory
	Author: Superxpdude
	Exports the inventory of the target unit to the clipboard. Exports in XPTLoadouts format.
	Borrows some code from (and is heavily influenced by) BIS_fnc_exportInventory
	
	Parameters:
		0: Object - Unit to have loadout exported
		
	Returns: Nothing
*/

#include "script_macros.hpp"

private _unit = _this param [0, player, [objNull]];

// Define some variables
private _br = tostring [13,10];
private _export = "";
private _loadout = getUnitLoadout _unit;
private _dlcs = getPersonUsedDLCs _unit;

// Array of all ace medical items
_aceMedical = [
	"ACE_adenosine",
	"ACE_atropine",
	"ACE_bloodIV",
	"ACE_bloodIV_250",
	"ACE_bloodIV_500",
	"ACE_Defibrillator",
	"ACE_elasticBandage",
	"ACE_epinephrine",
	"ACE_fieldDressing",
	"ACE_morphine",
	"ACE_packingBandage",
	"ACE_personalAidKit",
	"ACE_plasmaIV",
	"ACE_plasmaIV_250",
	"ACE_plasmaIV_500",
	"ACE_quikclot",
	"ACE_salineIV",
	"ACE_salineIV_250",
	"ACE_salineIV_500",
	"ACE_splint",
	"ACE_surgicalKit",
	"ACE_tourniquet"
];

// Define some quick functions
// Prints all elements of an array to the export without braces []
_fn_printArray = {
	// Based on BIS_fnc_exportInventory
	_array = _this;
	{
		if (_forEachIndex > 0) then {_export = _export + ",";};
		switch true do {
			case (_x isEqualType []): {
				_export = _export + "{";
				_x call _fn_printArray;
				_export = _export + "}";
			};
			case (_x isEqualType 0): {_export = _export + format ["%1",_x];};
			default {_export = _export + format ["""%1""",_x];}
		};
	} forEach _array;
};

// Creates an entry for an array.
_fn_addArray = {
	_name = _this select 0;	// Name of the array to print
	_array = _this select 1; // The array to print
	
	_export = _export + format ["%1[] = {", _name];
	_array call _fn_printArray;
	_export = _export + "};" + _br;
};

// This needs extra logic to split items from medical items
_fn_addItemArray = {
	_name = _this select 0; // Name of the array to print
	_array = _this select 1; // The array to print
	_medical = _this select 2; // If the array is medical or not
	
	_export = _export + format ["%1[] = {", _name];
	
	_itemArr = [];
	{
		switch true do {
			// All entries will be arrays
			// Check if the item is medical or not
			case (((_x select 0) in _aceMedical) AND _medical): {
				_itemArr pushBack _x
			};
			case (!((_x select 0) in _aceMedical) AND !_medical): {
				_itemArr pushBack _x
			};
		};
	} forEach _array;
	
	{
		if (_forEachIndex > 0) then {_export = _export + ",";};
		_export = _export + "{";
		_x call _fn_printArray;
		_export = _export + "}";
	} forEach _itemArr;
	
	_export = _export + "};" + _br;
};

_fn_tfarCheckLinkedItems = {
	_array = _this select 0;
	// Loop through the array
	{
		// If the item is a unique radio, replace it with the prototype
		if (_x call TFAR_fnc_isRadio) then {
			_array set [_forEachIndex, (configfile >> "CfgWeapons" >> _x >> "tf_parent") call BIS_fnc_getCfgData];
		};
	} forEach _array;
};

// Creates a single entry for the config
_fn_addValue = {
	_name = _this select 0; // The name of the value
	_value = _this select 1; // The value to add
	
	// If statements don't work nicely with the setup of the _export variable
	switch true do {
		case (_x isEqualType 0): {_export = _export + format ["%1 = %2;", _name, _value];};
		default {_export = _export + format ["%1 = ""%2"";", _name, _value];};
	};
	_export = _export + _br;
};

// Adds a comment to the export
_fn_addComment = {
	_text = _this select 0; // Text to add as a comment
	_export = _export + format ["//%1",_text];
	_export = _export + _br;
};

// Adds used DLCs as a comment to the export
_fn_dlcCheck = {
	if ((count _dlcs) > 0) then {
		private _text = "Requires the following DLC:";
		{
			private _appID = _x;
			// Manual override
			_dlcName = switch _x do {
				// Manual overrides for certain DLCs with internal codenames
				case 395180: {"Apex"}; // Expansion
				case 571710: {"LawsOfWar"}; // Orange
				case 1021790: {"Contact"}; // Enoch
				// Grab the name from the configs if not overridden
				default {
					configName (("((_x >> 'appID') call BIS_fnc_getCfgData) == _appID" configClasses (configFile >> "CfgMods")) select 0);
				};
			};
			if (isNil "_dlcName") then {
				_dlcName = format ["%1", _appID];
			};
			_text = _text + format [" %1,", _dlcName];
		} forEach _dlcs;
		_text = _text select [0,(count _text) - 1];
		[_text] call _fn_addComment;
	};
};

// Replace TFAR radios with base classes
_fn_tfarCheck = {
	_array = _this select 0;
	// Loop through each entry in the array
	{
		// If the item is a TFAR radio. Replace it with a base class.
		if (((_x select 0) isEqualType "") AND {(_x select 0) call TFAR_fnc_isRadio}) then {
			_x set [0, (configfile >> "CfgWeapons" >> (_x select 0) >> "tf_parent") call BIS_fnc_getCfgData];
		};
	} forEach _array;
};

// Remove unique radios from item arrays
if (count (_loadout select 3) > 0) then {
	[(_loadout select 3) select 1] call _fn_tfarCheck;
};
if (count (_loadout select 4) > 0) then {
	[(_loadout select 4) select 1] call _fn_tfarCheck;
};
if (count (_loadout select 5) > 0) then {
	[(_loadout select 5) select 1] call _fn_tfarCheck;
};

[_loadout select 9] call _fn_tfarCheckLinkedItems;

[] call _fn_dlcCheck;
["displayName", typeOf _unit] call _fn_addValue;
_export = _export + _br;

["primaryWeapon",_loadout select 0] call _fn_addArray;
["secondaryWeapon",_loadout select 1] call _fn_addArray;
["handgunWeapon",_loadout select 2] call _fn_addArray;
if (count (_loadout select 8) > 0) then {
	["binocular",(_loadout select 8) select 0] call _fn_addValue;
};
_export = _export + _br; // Line break for readability
if (count (_loadout select 3) > 0) then {
	["uniformClass",(_loadout select 3) select 0] call _fn_addValue;
};
if (count (_loadout select 6) > 0) then {
	["headgearClass",(_loadout select 6)] call _fn_addValue;
};
if (count (_loadout select 7) > 0) then {
	["facewearClass",(_loadout select 7)] call _fn_addValue;
};
if (count (_loadout select 4) > 0) then {
	["vestClass",(_loadout select 4) select 0] call _fn_addValue;
};
if (count (_loadout select 5) > 0) then {
	["backpackClass",(_loadout select 5) select 0] call _fn_addValue;
};
_export = _export + _br; // Line break for readability
["linkedItems",_loadout select 9] call _fn_addArray;
_export = _export + _br; // Line break for readability
if (count (_loadout select 3) > 0) then {
	["uniformItems",(_loadout select 3) select 1,false] call _fn_addItemArray;
};
if (count (_loadout select 4) > 0) then {
	["vestItems",(_loadout select 4) select 1,false] call _fn_addItemArray;
};
if (count (_loadout select 5) > 0) then {
	["backpackItems",(_loadout select 5) select 1,false] call _fn_addItemArray;
};
_export = _export + _br; // Line break for readability
if (count (_loadout select 3) > 0) then {
	["basicMedUniform",(_loadout select 3) select 1,true] call _fn_addItemArray;
};
if (count (_loadout select 4) > 0) then {
	["basicMedVest",(_loadout select 4) select 1,true] call _fn_addItemArray;
};
if (count (_loadout select 5) > 0) then {
	["basicMedBackpack",(_loadout select 5) select 1,true] call _fn_addItemArray;
};

copytoclipboard _export;
_export