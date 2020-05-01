/*
	XPT_fnc_loadInventory_legacy
	Author: Superxpdude
	Loads a custom inventory for a unit from a config file. Uses the old XPTLoadouts format
	
	Config should be in the following format:
	
	class loadoutName
	{
		displayName = "Example Loadout"; // Currently unused, basically just a human-readable name for the loadout
		
		weapons[] = {"arifle_MXC_F", "launch_B_Titan_short_F", "hgun_ACPC2_F", "Binocular"}; // Weapons for the unit, fills the primary weapon, launcher, pistol, and binocular slots
		primaryWeaponItems[] = {"optic_ACO", "acc_flashlight", "30Rnd_65x39_caseless_mag"}; // Primary weapon items. Includes magazine you want loaded initially
		secondaryWeaponItems[] = {"Titan_AP"}; // Secondary weapon items (launchers). Includes magazine you want loaded initially.
		handgunItems[] = {"9Rnd_45ACP_Mag"}; // Handgun items. Includes magazine you want loaded initially.
		
		uniformClass = "U_B_CombatUniform_mcam_tshirt";
		headgearClass = "H_Watchcap_blk";
		facewearClass = "";
		vestClass = "V_Chestrig_khk";
		backpackClass = "B_AssaultPack_mcamo";
		
		linkedItems[] = {"ItemMap", "ItemCompass", "ItemWatch", "ItemRadio"}; // Linked items for the unit, use for map, compass, radio, watch, gps, and NVGs
		uniformItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in uniform. Includes weapon magazines
		vestItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in vest. Includes weapon magazines
		backpackItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in backpack. Includes weapon magazines
		
		basicMedUniform[] = {}; // Items to be placed in the uniform only when basic medical is being used
		basicMedVest[] = {}; // Items to be placed in the vest only when basic medical is being used
		basicMedBackpack[] = {}; // Items to be placed in the backpack only when basic medical is being used
		
		advMedUniform[] = {}; // Items to be placed in the uniform only when advanced medical is being used
		advMedVest[] = {}; // Items to be placed in the vest only when advanced medical is being used
		advMedBackpack[] = {}; // Items to be placed in the backpack only when advanced medical is being used
	};
	
	Parameters:
		0: Object - Unit to apply loadout
		1: Config - Loadout to apply.
		
	Returns: Bool
		True if loadout was applied successfully
		False if loadout was not applied successfully
*/

#include "script_macros.hpp"

// Define variables
private ["_unit", "_class", "_subclasses"];
params [
	["_unit", nil, [objNull]],
	["_class", nil, [configNull]]
];

// Exit the script if _unit is not an object or _class is not a config class
if ((isNil "_unit") or (isNil "_class")) exitWith {false};

// Define some sub-functions
private _fn_itemType = {
	private ["_return"];
	if (isClass (configFile >> "CfgMagazines" >> (_this select 0))) then {
		// If it's a magazine, grab the ammo count
		_return = [(_this select 0),(_this select 1),(configFile >> "CfgMagazines" >> (_this select 0) >> "count") call BIS_fnc_getCfgData];
	} else {
		// If it's an item, return the item
		_return = _this;
	};
	_return
};

private _fn_weaponItem = {
	_this params ["_weapon", "_item"];
	// Define variables
	private _return = [-1];
	// Check if the item has an ItemInfo "type" definition
	private _type = (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") call BIS_fnc_getCfgData;
	if (isNil "_type") then {
		// Magazine
		
		// Check if the magazine is for the primary muzzle
		private _primaryMag = false;
		{
			private _magWell = _x;
			{
				if (_item in (_x call BIS_fnc_getCfgData)) then {
					_primaryMag = true;
				};
			} forEach (configProperties [(configFile >> "CfgMagazineWells" >> _magWell)]);
		} forEach ((configFile >> "CfgWeapons" >> _weapon >> "magazineWell") call BIS_fnc_getCfgData);
		if (_primaryMag OR (_item in ((configFile >> "CfgWeapons" >> _weapon >> "magazines") call BIS_fnc_getCfgData))) then {
			// Magazine in primary magazines array. We're assuming this means the primary muzzle.
			_return set [0,4]; // Mark this value for the primary muzzle
		} else {
			// Magazine not in magazines array. Assuming this means secondary muzzle.
			_return set [0,5]; // Mark this value for the secondary muzzle
		};
		
		// Get the maximum ammo count for the magazine.
		private _ammo = (configFile >> "CfgMagazines" >> _item >> "count") call BIS_fnc_getCfgData;
		_return set [1,[_item,_ammo]];
		
	} else {
		// Weapon attachment
		
		// Find out what kind of weapon attachment it is.
		switch (_type) do {
			case 101: {_return = [1, _item];}; // Suppressor
			case 201: {_return = [3, _item];}; // Optics
			case 301: {_return = [2, _item];}; // Flashlight/Laser
			case 302: {_return = [6, _item];}; // Bipod
		};
	};
	
	// Return a value
	_return
};

// If the unit is local, continue to changing its loadout
// Check if the specified class has sub-loadouts
_subclasses = "true" configClasses _class;
if ((count _subclasses) > 0) then {
	// If we have any subclasses, select a random one.
	_class = selectRandom _subclasses;
};

// Retrieve loadout data from config files
private ["_displayName", "_weapons", "_primaryWeaponItems", "_secondaryWeaponItems", "_handgunItems", "_uniformClass", "_headgearClass", "_facewearClass", "_vestClass", "_backpackClass", "_linkedItems", "_uniformItems", "_vestItems", "_backpackItems", "_uniformMedical", "_vestMedical", "_backpackMedical"];
_displayName = [((_class >> "displayName") call BIS_fnc_getCfgData)] param [0, "", [""]];
_weapons = [((_class >> "weapons") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_primaryWeaponItems = [((_class >> "primaryWeaponItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_secondaryWeaponItems = [((_class >> "secondaryWeaponItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_handgunItems = [((_class >> "handgunItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_uniformClass = [((_class >> "uniformClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
_headgearClass = [((_class >> "headgearClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
_facewearClass = [((_class >> "facewearClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
_vestClass = [((_class >> "vestClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
_backpackClass = [((_class >> "backpackClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
_linkedItems = [((_class >> "linkedItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_uniformItems = [((_class >> "uniformItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_vestItems = [((_class >> "vestItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
_backpackItems = [((_class >> "backpackItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];

// Retrieve medical items from config file.
if ((["xpt_medical_level", 0] call BIS_fnc_getParamValue) == 0) then {
	// Only load these classes if basic medical is being used.
	_uniformMedical = [((_class >> "basicMedUniform") call BIS_fnc_getCfgData)] param [0, [], [[]]];
	_vestMedical = [((_class >> "basicMedVest") call BIS_fnc_getCfgData)] param [0, [], [[]]];
	_backpackMedical = [((_class >> "basicMedBackpack") call BIS_fnc_getCfgData)] param [0, [], [[]]];
} else {
	// Only load these classes if advanced medical is being used.
	_uniformMedical = [((_class >> "advMedUniform") call BIS_fnc_getCfgData)] param [0, [], [[]]];
	_vestMedical = [((_class >> "advMedVest") call BIS_fnc_getCfgData)] param [0, [], [[]]];
	_backpackMedical = [((_class >> "advMedBackpack") call BIS_fnc_getCfgData)] param [0, [], [[]]];
};

// Define our variables for setUnitLoadout
//private _loadout = [[],[],[],[],[],[],"","",[],[]];
private _lPrimary = ["","","","",[],[],""];
private _lSecondary = + _lPrimary; // All weapons use the same array structure
private _lHandgun = + _lPrimary; // All weapons use the same array structure
private _lUniformItems = [];
private _lVestItems = [];
private _lBackpackItems = [];
private _lBinocular = + _lPrimary; // All weapons use the same array structure
private _lLinkedItems = ["","","","","",""];

// Start with the weapons
{
	switch true do {
		case (_x isKindOf ["Rifle", configFile >> "CfgWeapons"]): {_lPrimary set [0, _x];};
		case (_x isKindOf ["Pistol", configFile >> "CfgWeapons"]): {_lHandgun set [0, _x];};
		case (_x isKindOf ["Launcher", configFile >> "CfgWeapons"]): {_lSecondary set [0, _x];};
		case (_x isKindOf ["Binocular", configFile >> "CfgWeapons"]): {_lBinocular set [0, _x];};
		default {systemChat "TEMP MESSAGE REPLACE WITH ERROR CALL";};
	};
} forEach _weapons;

// Primary weapon items
{
	private _temp = [_lPrimary select 0,_x] call _fn_weaponItem;
	if ((_temp select 0) > 0) then {
		_lPrimary set _temp;
	};
} forEach _primaryWeaponItems;

// Secondary weapon items
{
	private _temp = [_lSecondary select 0,_x] call _fn_weaponItem;
	if ((_temp select 0) > 0) then {
		_lSecondary set _temp;
	};
} forEach _secondaryWeaponItems;


// Handgun weapon items
{
	private _temp = [_lHandgun select 0,_x] call _fn_weaponItem;
	if ((_temp select 0) > 0) then {
		_lHandgun set _temp;
	};
} forEach _handgunItems;

// Items carried in inventory
_lUniformItems = (_uniformItems + _uniformMedical) apply {_x call _fn_itemType};
_lVestItems = (_vestItems + _vestMedical) apply {_x call _fn_itemType};
_lBackpackItems = (_backpackItems + _backpackMedical) apply {_x call _fn_itemType};

// Linked items
{
	private _simulation = (configFile >> "CfgWeapons" >> _x >> "simulation") call BIS_fnc_getCfgData;
	private _type = (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type") call BIS_fnc_getCfgData;
	if (isNil "_simulation") then {_simulation = ""};
	if (isNil "_type") then {_type = -1};
	
	switch true do {
		case (_simulation == "ItemMap"): {_lLinkedItems set [0, _x];};
		case (_type == 621);
		case (_simulation == "ItemGPS"): {_lLinkedItems set [1, _x];};
		case (_simulation == "ItemRadio"): {_lLinkedItems set [2, _x];};
		case (_simulation == "ItemCompass"): {_lLinkedItems set [3, _x];};
		case (_simulation == "ItemWatch"): {_lLinkedItems set [4, _x];};
		case (_type == 616): {_lLinkedItems set [5, _x];};
		default {systemChat "TEMP MESSAGE REPLACE WITH ERROR CALL";};
	};
} forEach _linkedItems;

// Merge the uniform, vest, and backpack arrays
private _uniformArray = [_uniformClass,_lUniformItems];
private _vestArray = [_vestClass,_lVestItems];
private _backpackArray = [_backpackClass,_lBackpackItems];

// Fix for "Bad Vehicle Type" errors regarding weapons and inventories
{
	// If the main classname is undefined, replace the array with an empty one.
	if ((_x select 0) == "") then {
		_x deleteRange [0,10]; // Ensure the entire array is emptied
	};
} forEach [_lPrimary, _lSecondary, _lHandgun, _uniformArray, _vestArray, _backpackArray, _lBinocular];

// Assemble the loadout
/*
_loadout set [0, _lPrimary];
_loadout set [1, _lSecondary];
_loadout set [2, _lHandgun];
_loadout set [3, _uniformArray];
_loadout set [4, _vestArray];
_loadout set [5, _backpackArray];
_loadout set [6, _headgearClass];
_loadout set [7, _facewearClass];
_loadout set [8, _lBinocular];
_loadout set [9, _lLinkedItems];
*/
private _loadout = [
	_lPrimary,
	_lSecondary,
	_lHandgun,
	_uniformArray,
	_vestArray,
	_backpackArray,
	_headgearClass,
	_facewearClass,
	_lBinocular,
	_lLinkedItems
];
_unit setUnitLoadout _loadout;

// Return true if script is completed.
true 