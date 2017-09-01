/*
	SXP_fnc_loadInventory
	Author: Superxpdude
	Loads a custom inventory for a unit from a config file
	
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
		vestClass = "V_Chestrif_khk";
		backpackClass = "B_AssaultPack_mcamo";
		
		linkedItems[] = {"ItemMap", "ItemCompass", "ItemWatch", "ItemRadio"}; // Linked items for the unit, use for map, compass, radio, watch, gps, and NVGs
		uniformItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in uniform. Includes weapon magazines
		vestItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in vest. Includes weapon magazines
		backpackItems[] = {{"FirstAidKit", 3}, {"30Rnd_65x39_caseless_mag", 4}}; // Items to place in backpack. Includes weapon magazines
	};
	
	Parameters:
		0: Object - Unit to apply loadout
		1: Config - Loadout to apply.
		
	Returns: Bool
		True if loadout was applied successfully
		False if loadout was not applied successfully
*/

// Define variables
private ["_unit", "_class", "_subclasses"];
params [
	["_unit", nil, [objNull]],
	["_class", nil, [configNull]]
];

// Exit the script if _unit is not an object or _class is not a config class
if ((isNil "_unit") or (isNil "_class")) exitWith {false};

// If unit is not local, we need to send to the command to the owner
if (!local _unit) then {
	// If this has not been run on the server, we need to send it to the server to find the right owner
	if (!isServer) then {
		// Send the script on the server
		[_unit, _class] remoteExec ["SXP_fnc_loadInventory", 2];
	} else {
		// If this has been run on the server, find out who the owner is (since we've already confirmed it isn't local)
		[_unit, _class] remoteExec ["SXP_fnc_loadInventory", owner _unit];
	};
} else {
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
	_weapons = [((_class >> "weapons") call BIS_fnc_getCfgData)] param [0, "", [[""]]];
	_primaryWeaponItems = [((_class >> "primaryWeaponItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	_secondaryWeaponItems = [((_class >> "secondaryWeaponItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	_handgunItems = [((_class >> "handgunItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	_uniformClass = [((_class >> "uniformClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
	_headgearClass = [((_class >> "headgearClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
	_facewearClass = [((_class >> "facewearClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
	_vestClass = [((_class >> "vestClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
	_backpackClass = [((_class >> "backpackClass") call BIS_fnc_getCfgData)] param [0, "", [""]];
	_linkedItems = [((_class >> "linkedItems") call BIS_fnc_getCfgData)] param [0, "", [[]]];
	_uniformItems = [((_class >> "uniformItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	_vestItems = [((_class >> "vestItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	_backpackItems = [((_class >> "backpackItems") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	
	// Retrieve medical items from config file.
	if ((getMissionConfigValue "ace_medical_level") == 1) then {
		// Only load these classes if basic medical is being used.
		_uniformMedical = [((_class >> "basicMedUniform") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
		_vestMedical = [((_class >> "basicMedVest") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
		_backpackMedical = [((_class >> "basicMedBackpack") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	} else {
		// Only load these classes if advanced medical is being used.
		_uniformMedical = [((_class >> "advMedUniform") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
		_vestMedical = [((_class >> "advMedVest") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
		_backpackMedical = [((_class >> "advMedBackpack") call BIS_fnc_getCfgData)] param [0, [""], [[]]];
	};
	
	// Remove the existing loadout from the unit
	removeAllContainers _unit; // Removes uniform, vest, and backpack
	removeAllAssignedItems _unit; // Removes map, gps, watch, compass, radio, and NVGs
	removeHeadgear _unit; // Removes the unit's headgear
	removeGoggles _unit; // Removes the unit's goggles
	removeAllWeapons _unit; // Removes all weapons
	
	// Begin adding the equipment to the unit
	// Start by adding clothing
	_unit forceAddUniform _uniformClass;
	_unit addVest _vestClass;
	_unit addBackpackGlobal _backpackClass;
	_unit addHeadgear _headgearClass;
	_unit addGoggles _facewearClass;
	
	// Next add weapons and attachments
	{_unit addWeapon _x} forEach _weapons;
	{_unit addPrimaryWeaponItem _x} forEach _primaryWeaponItems;
	{_unit addSecondaryWeaponItem _x} forEach _secondaryWeaponItems;
	{_unit addHandgunItem _x} forEach _handgunItems;
	
	// Add linked items
	{_unit linkItem _x} forEach _linkedItems;
	
	// Add items and magazines to the uniform, vest, and backpack
	{
		for "_i" from 1 to (_x select 1) do {
			_unit addItemToUniform (_x select 0)
		};
	} forEach (_uniformItems + _uniformMedical);
	{
		for "_i" from 1 to (_x select 1) do {
			_unit addItemToVest (_x select 0)
		};
	} forEach (_vestItems + _vestMedical);
	{
		for "_i" from 1 to (_x select 1) do {
			_unit addItemToBackpack (_x select 0)
		};
	} forEach (_backpackItems + _backpackMedical);
	
	// Copy the unit's old radio settings (if they have any)
	// Use spawn since this function waits for TFAR to be finished assigning new radios
	[] spawn SXP_fnc_loadRadioSettings;
};
// Return true if script is completed.
true 