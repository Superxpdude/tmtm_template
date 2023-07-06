/*
	XPT_fnc_getLoadoutArray
	Author: Superxpdude, erem2k

	Resolves loadout array for a unit from a config file
    Used by default in XPT_fnc_loadInventory
	
	Config should be in the following format:
	
	class loadoutName
	{
		displayName = "Example Loadout"; // Currently unused, basically just a human-readable name for the loadout
		
		// Weapon definitions all use the following format:
		// {Weapon Classname, Suppressor, Pointer (Laser/Flashlight), Optic, [Primary magazine, ammo count], [Secondary Magazine (GL), ammo count], Bipod}
		// Any empty definitions must be defined as an empty string, or an empty array. Otherwise the loadout will not apply correctly.
		
		primaryWeapon[] = {"arifle_MXC_F", "", "acc_flashlight", "optic_ACO", ["30Rnd_65x39_caseless_mag",30], [], ""}; // Primary weapon definition
		secondaryWeapon[] = {"launch_B_Titan_short_F", "", "", "", ["Titan_AP", 1], [], ""}; // Secondary weapon (Launcher) definition.
		handgunWeapon[] = {"hgun_ACPC2_F", "", "", "", ["9Rnd_45ACP_Mag", 9], [], ""}; // Handgun definition
		binocular = "Binocular";
		
		uniformClass = "U_B_CombatUniform_mcam_tshirt";
		headgearClass = "H_Watchcap_blk";
		facewearClass = "";
		vestClass = "V_Chestrig_khk";
		backpackClass = "B_AssaultPack_mcamo";
		
		// Linked items requires all six definitions to be present. Use empty strings if you do not want to add that item.
		linkedItems[] = {"ItemMap", "ItemGPS", "ItemRadio", "ItemCompass", "ItemWatch", ""}; // Linked items for the unit, must follow the order of: Map, GPS, Radio, Compass, Watch, NVGs.
		
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
		0: Config - Loadout to apply.
		
	Returns: Loadout array
        Compliant with setUnitLoadout array
        https://community.bistudio.com/wiki/setUnitLoadout
*/

params [
	["_unit", nil, [objNull]],
	["_baseClass", nil, [configNull]]
];

// Exit the script if _unit is not an object or _class is not a config class
if ((isNil "_unit") or (isNil "_baseClass")) exitWith {[]};

// Check if the specified class has sub-loadouts
_subclasses = "true" configClasses _baseClass;
if ((count _subclasses) > 0) then {
	// If we have any subclasses, select a random one.
	_class = selectRandom _subclasses;
	_isSubclass = true;
} else {
	_class = _baseClass;
};

// Retrieve loadout data from config files
private _displayName = [((_class >> "displayName") call BIS_fnc_getCfgData)] param [0, "", [""]];
private _primaryWeapon = [((_class >> "primaryWeapon") call BIS_fnc_getCfgData)] param [0, [], [[]], [0,7]];
private _secondaryWeapon = [((_class >> "secondaryWeapon") call BIS_fnc_getCfgData)] param [0, [], [[]], [0,7]];
private _handgunWeapon = [((_class >> "handgunWeapon") call BIS_fnc_getCfgData)] param [0, [], [[]], [0,7]];
private _binocular = [((_class >> "binocular") call BIS_fnc_getCfgData)] param [0, "", [""]];
private _uniformClass = [((_class >> "uniformClass") call BIS_fnc_getCfgData)] param [0, "", ["",[]]];
private _headgearClass = [((_class >> "headgearClass") call BIS_fnc_getCfgData)] param [0, "", ["",[]]];
private _facewearClass = [((_class >> "facewearClass") call BIS_fnc_getCfgData)] param [0, "", ["",[]]];
private _vestClass = [((_class >> "vestClass") call BIS_fnc_getCfgData)] param [0, "", ["",[]]];
private _backpackClass = [((_class >> "backpackClass") call BIS_fnc_getCfgData)] param [0, "", ["",[]]];
private _linkedItems = [((_class >> "linkedItems") call BIS_fnc_getCfgData)] param [0, [], [[]], 6];
private _uniformItems = [((_class >> "uniformItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
private _vestItems = [((_class >> "vestItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];
private _backpackItems = [((_class >> "backpackItems") call BIS_fnc_getCfgData)] param [0, [], [[]]];

// Retrieve medical items from config file.
if ((["xpt_medical_level", 0] call BIS_fnc_getParamValue) == 0) then {
	// Only load these classes if basic medical is being used.
	_uniformItems append ([((_class >> "basicMedUniform") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
	_vestItems append ([((_class >> "basicMedVest") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
	_backpackItems append ([((_class >> "basicMedBackpack") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
} else {
	// Only load these classes if advanced medical is being used.
	_uniformItems append ([((_class >> "advMedUniform") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
	_vestItems append ([((_class >> "advMedVest") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
	_backpackItems append ([((_class >> "advMedBackpack") call BIS_fnc_getCfgData)] param [0, [], [[]]]);
};

// Function to ensure that magazines have an ammo count defined
private _fn_fixMagazine = {
	private _x = _this;
	// Only run if the item does not have a third entry in the array. Do not run if the item is a weapon.
	if ((count _x == 2) AND {!((_x select 0) isEqualType [])}) then {
		_classname = (_x select 0);
		if (isClass (configFile >> "CfgMagazines" >> _classname)) then {
			["warning", format ["Magazine type [%1] has no ammo count defined in loadout [%2].",_classname, configName _baseClass], "local"] call XPT_fnc_log;
			_x set [2, (configFile >> "CfgMagazines" >> _classname >> "count") call BIS_fnc_getCfgData];
		};
	};
	_x
};

_uniformItems = _uniformItems apply {_x call _fn_fixMagazine};
_vestItems = _vestItems apply {_x call _fn_fixMagazine};
_backpackItems = _backpackItems apply {_x call _fn_fixMagazine};

// Equipment randomization support
private _fn_equipmentSelect = {
	private _return = if (_this isEqualType []) then {
		selectRandom _this
	} else {
		_this
	};
	_return
};

_uniformClass = _uniformClass call _fn_equipmentSelect;
_headgearClass = _headgearClass call _fn_equipmentSelect;
_facewearClass = _facewearClass call _fn_equipmentSelect;
_vestClass = _vestClass call _fn_equipmentSelect;
_backpackClass = _backpackClass call _fn_equipmentSelect;

// Merge some arrays into their main unit loadout entry
private _uniformArray = [_uniformClass, _uniformItems];
private _vestArray = [_vestClass, _vestItems];
private _backpackArray = [_backpackClass, _backpackItems];
private _binocularArray = [_binocular,"","","",[],[],""];

// Check if the binoculars are a laser designator
private _binocularMagazines = (configFile >> "CfgWeapons" >> _binocular >> "magazines") call BIS_fnc_getCfgDataArray;
if ((count _binocularMagazines) > 0) then {
	private _laserBattery = _binocularMagazines select 0;
	private _batteryCount = (configFile >> "CfgMagazines" >> _laserBattery >> "count") call BIS_fnc_getCfgData;
	_binocularArray set [4,[_laserBattery,_batteryCount]];
};

// Fix for "Bad Vehicle Type" errors regarding weapons and inventories
{
	// If the main classname is undefined, replace the array with an empty one.
	if ((_x select 0) == "") then {
		_x deleteRange [0,10]; // Ensure the entire array is emptied
	};
} forEach [_primaryWeapon, _secondaryWeapon, _handgunWeapon, _uniformArray, _vestArray, _backpackArray, _binocularArray];

// Format and return our unit loadout array.
private _loadout = [
	_primaryWeapon,
	_secondaryWeapon,
	_handgunWeapon,
	_uniformArray,
	_vestArray,
	_backpackArray,
	_headgearClass, 
	_facewearClass,
	_binocularArray,
	_linkedItems
];

_loadout;