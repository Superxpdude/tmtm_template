/*
	XPT_fnc_audit
	Author: Superxpdude
	Performs rudimentary checks on a mission to determine if it would pass a TMTM audit.
	
	Parameters:
		No parameters. Checks entire mission.
		
	Returns: Nothing
*/

// Do not run if our mission was not run from the editor
if !(is3DEN or is3DENPreview) exitWith {
	systemChat "Audit can only be run in 3DEN or 3DEN preview.";
};

// Initialize some variables
private _auditMessages = []; // Array of issue strings
private _warningMessages = []; // Array of warnings
private _failMessages = []; // Array of fail messages

// Excluded CBA settings to check (set by the template itself)
// These variables must be entirely lowercase for string matching to work correctly
private _excludedCBASettings = [
	// TFAR radio setup
	"tfar_radiocodesdisabled",
	"tfar_givelongrangeradiotogroupleaders",
	"tfar_givepersonalradiotoregularsoldier",
	"tfar_samesrfrequenciesforside",
	"tfar_samelrfrequenciesforside",
	"tfar_setting_defaultfrequencies_sr_west",
	"tfar_setting_defaultfrequencies_sr_east",
	"tfar_setting_defaultfrequencies_sr_independent",
	"tfar_setting_defaultfrequencies_lr_west",
	"tfar_setting_defaultfrequencies_lr_east",
	"tfar_setting_defaultfrequencies_lr_independent",
	"tfar_radiocode_west",
	"tfar_radiocode_east",
	"tfar_radiocode_independent",
	// ACE3 medical (lobby parameters)
	"ace_medical_limping",
	"ace_medical_fractures",
	"ace_medical_treatment_advanceddiagnose",
	"ace_medical_treatment_advancedbandages",
	"ace_medical_treatment_cleartraumaafterbandage",
	"ace_medical_treatment_advancedmedication",
	// ACE3 lobby parameters
	"ace_medical_fataldamagesource",
	"ace_medical_statemachine_fatalinjuriesplayer",
	"ace_medical_statemachine_cardiacarresttime",
	"ace_medical_playerdamagethreshold",
	"ace_medical_aidamagethreshold",
	"acex_viewrestriction_mode",
	"acex_viewrestriction_modeselectivefoot",
	"acex_viewrestriction_modeselectiveland",
	"acex_viewrestriction_modeselectiveair",
	"acex_viewrestriction_modeselectivesea"
];

// Protected CBA settings prefixes. Error our if *any* of these are forced at the mission level.
// Must be all lowercase for string comparison.
private _protectedCBASettings = [
	"ace_nametags_",
	"diwako_dui_",
	"pdf_envg_", // Fawks' Enhanced NVGs
	"tfar_teamspeak_",
	"wha_nametags_"
];

// ACE3 bandage classnames for validation
// Must be all lowercase for string comparison
private _aceBandageClasses = [
	"ace_fielddressing",
	"ace_elasticbandage",
	"ace_packingbandage",
	"ace_quikclot"
];


// ---------------------------------------------------
// --------------- BEGIN MISSION CHECK ---------------
// ---------------------------------------------------

// Get mission information
private _respawnTimer = getMissionConfigValue ["respawnDelay", 1e10];

// Basic validation on the briefingName
private _briefingNameType = toLower (((getMissionConfigValue ["briefingName", "MISSING"]) splitString " ") select 0);
switch (true) do {
	case (isNil "_briefingNameType");
	case (_briefingNameType == "missing"): {
		_failMessages append ["ERROR: Could not determine mission type in briefingName"];
	};
	case !((toLower _briefingNameType) in ["coop", "tvt", "cotvt", "zeus", "zgm", "rpg"]): {
		_failMessages append [format ["ERROR: Invalid mission type in briefingName: %1", _briefingNameType]];
	};
	default {
		_auditMessages append [format ["Mission type validated as: %1", _briefingNameType]];
	};
};

// Check lobby parameters
// ACE view restriction
private _viewRestriction = [(getMissionConfig "params" >> "acex_viewrestriction_mode" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];
private _viewRestrictionFoot = [(getMissionConfig "params" >> "acex_viewrestriction_modeSelectiveFoot" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];
private _viewRestrictionLand = [(getMissionConfig "params" >> "acex_viewrestriction_modeSelectiveLand" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];
private _viewRestrictionAir = [(getMissionConfig "params" >> "acex_viewrestriction_modeSelectiveAir" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];
private _viewRestrictionSea = [(getMissionConfig "params" >> "acex_viewrestriction_modeSelectiveSea" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];

// Player fatal injuries / fatal damage source
private _fatalInjuries = [(getMissionConfig "params" >> "ace_medical_statemachine_fatalInjuriesPlayer" >> "default") call BIS_fnc_getCfgData] param [0, 1, [0]];
private _fatalDamageSource = [(getMissionConfig "params" >> "ace_medical_fatalDamageSource" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];


// PVP-type specific checks
switch (_briefingNameType) do {
	case "rptvt";
	case "tvt": {
		// TvT mission
		if (_viewRestriction != 1) then {
			_warningMessages append ["WARNING: PvP missions are recommended to use first-person view restrictions"];
		};
	};
	case "cotvt": {
		// CoTvT missions don't have view restriction requirements like COOP does
		// Fatal injuries checking
		switch (_fatalInjuries) do {
			case 0: {
				// Always
				if (_fatalDamageSource != 0) then {
					_failMessages append ["ERROR: ""Fatal Damage Source"" must be set to ""Only large hits"" when fatal injuries are set to ""Always""."];
				};
				if (_respawnTimer > 180) then {
					_warningMessages append ["WARNING: CoTvT Respawn timer exceeds 3 minutes with ""Fatal Injuries"" set to ""Always"". Ensure main player force respawns within 3 minutes."];
				};
				// Append a warning message to validate quick reinsertion
				_warningMessages append ["WARNING: Mission has ""Fatal Injuries"" set to ""Always"". Ensure that the mission has quick reinsertion for respawns."];
			};
			case 1: {
				// Only in cardiac arrest
				// A respawn timer over 30 minutes is effectively disabled
				if (_respawnTimer > 1800) then {
					_failMessages append ["ERROR: Missions with ""Fatal Injuries"" set to ""In Cardiac Arrest"" must have respawns enabled."]
				};
			};
		};
	};
	default {
		// Non-PVP mission
		switch (_viewRestriction) do {
			case 1: {
				_failMessages append ["ERROR: COOP main ops are not allowed to force first-person view for all."];
			};
			case 3: {
				// Selective
				if (_viewRestrictionLand != 0) then {
					_failMessages append ["ERROR: COOP main ops are not permitted to force first-person view in vehicles."];
				};
				if (_viewRestrictionAir != 0) then {
					_failMessages append ["ERROR: COOP main ops are not permitted to force first-person view in aircraft."];
				};
				if (_viewRestrictionSea != 0) then {
					_failMessages append ["ERROR: COOP main ops are not permitted to force first-person view in boats."];
				};
			};
		};
		
		// Fatal injuries checking
		switch (_fatalInjuries) do {
			case 0: {
				// Always
				if (_fatalDamageSource != 0) then {
					_failMessages append ["ERROR: ""Fatal Damage Source"" must be set to ""Only large hits"" when fatal injuries are set to ""Always""."];
				};
				if (_respawnTimer > 180) then {
					_failMessages append ["ERROR: Respawn timer exceeds 3 minutes with ""Fatal Injuries"" set to ""Always""."];
				};
				// Append a warning message to validate quick reinsertion
				_warningMessages append ["WARNING: Mission has ""Fatal Injuries"" set to ""Always"". Ensure that the mission has quick reinsertion for respawns."];
			};
			case 1: {
				// Only in cardiac arrest
				// A respawn timer over 30 minutes is effectively disabled
				if (_respawnTimer > 1800) then {
					_failMessages append ["ERROR: Missions with ""Fatal Injuries"" set to ""In Cardiac Arrest"" must have respawns enabled."]
				};
			};
		};
	};
};

// Medical preset
private _medicalPreset = [(getMissionConfig "params" >> "xpt_medical_level" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];

if (_medicalPreset != 0) then {
	_failMessages append ["ERROR: Mission does not use the ""Standard"" medical preset."];
};

// Check respawn timer
if (_respawnTimer > 600) then {
	_warningMessages append [format ["WARNING: Mission has respawns disabled (RespawnTime: %1). Please verify that the mission will take less than one hour to complete.", _respawnTimer]];
};

// Check respawn button
private _respawnButton = getMissionConfigValue ["respawnButton", 1];
if (_respawnButton == 0) then {
	_failMessages append ["ERROR: Disabling the respawn button is not permitted for main ops."];
};

// Check AFM
private _forceRotorLib = getMissionConfigValue ["forceRotorLibSimulation", 0];
if (_forceRotorLib != 0) then {
	_failMessages append ["ERROR: Forcing Helicopter AFM (on or off) is not permitted."];
};

// Check how many CBA settings are set at the mission level
private _forcedCBASettings = 0;
// Iterate through all cba settings to check if they are forced at the mission level
{
	private _setting = _x;
	if !((toLower _setting) in _excludedCBASettings) then {
		_priority = [_setting, "mission"] call cba_settings_fnc_priority;
		if (_priority > 0) then {
			_forcedCBASettings = _forcedCBASettings + 1;
			// Check for protected values
			{
				if (_x in _setting) then {
					_failMessages append [format ["ERROR: Mission overrides protected CBA setting: %1", _setting]];
				};
			} forEach _protectedCBASettings
		};
	};
} forEach cba_settings_allSettings;

_auditMessages append [format ["CBA settings forced: %1", _forcedCBASettings]];
// If the mission overrides a lot of CBA settings, throw a warning
if (_forcedCBASettings >= 10) then {
	_warningMessages append [format ["WARNING: More than 10 CBA settings forced at mission level. Please verify forced mission settings.", _forcedCBASettings]];
};

// --------------------------------------------
// ---------- Loadout checking block ----------
// --------------------------------------------
private _xptLoadoutsEnabled = if (getMissionConfigValue ["XPT_customLoadouts", 0] == 1) then {true} else {false};

// We run different checks if XPT loadouts is enabled
if (_xptLoadoutsEnabled) then {
	// XPTLoadouts enabled. Check config unit loadouts.
	_auditMessages append ["XPTLoadouts enabled. Checking config loadouts."];
	
	// Validate that all playable units have a loadout defined
	// This can't validate loadouts assigned by the "XPT_loadout" object variable since there's no way to get that value in the 3DEN editor.
	private _playableClasses = [];
	{
		_playableClasses pushBackUnique _x;
	} forEach (([player] + playableUnits) apply {typeOf _x}); // Playableunits does not include zeus or HC
	
	// Get a list of loadout classes in our XPTLoadouts config
	// This part ignores anything in XPTLoadoutGroups, since it's assumed that those aren't applied at mission start
	// Additionally, XPTLoadoutGroups will fall back to the base XPTLoadouts definition if a class cannot be found
	private _configLoadoutClasses = "true" configClasses (missionConfigFile >> "CfgXPT" >> "loadouts") apply {toLower configName _x};
	
	// Iterate through our playable classes to confirm that we have loadouts for all classes
	{
		if !((toLower _x) in _configLoadoutClasses) then {
			_failMessages append [format ["ERROR: XPTLoadouts class missing for unit type: %1", _x]];
		};
	} forEach _playableClasses;
	
	// Perform some basic "medical amount" validation on loadout classes
	// Ignore the default loadouts, since they're unlikely to contain anything
	{
		private _mainClass = _x;
		private _subClasses = "true" configClasses _mainClass;
		private _loadoutClasses = if ((count _subClasses) > 0) then {
			_subClasses
		} else {
			[_x]
		};
		
		// Iterate through all subclasses if applicable
		{
			private _loadoutClass = _x;
			// Get medical data from our config
			private _uniformMedical = [((_loadoutClass >> "basicMedUniform") call BIS_fnc_getCfgData)] param [0, [], [[]]];
			private _vestMedical = [((_loadoutClass >> "basicMedVest") call BIS_fnc_getCfgData)] param [0, [], [[]]];
			private _backpackMedical = [((_loadoutClass >> "basicMedBackpack") call BIS_fnc_getCfgData)] param [0, [], [[]]];
			
			// Count how many bandages the loadout has
			private _bandageCount = 0;
			{
				// Entries will be in the form of [itemClass, count]
				if ((toLower (_x select 0)) in _aceBandageClasses) then {
					// Item is a bandage. Increment our count
					_bandageCount = _bandageCount + (_x select 1);
				};
			} forEach (_uniformMedical + _vestMedical + _backpackMedical);
			
			// Check to see if we have sufficient medical
			if (_bandageCount < 8) then {
				if (_loadoutClass == _mainClass) then {
					_warningMessages append [format ["WARNING: Loadout class '%1' has very low medical supplies. Bandages [%2]", configName _loadoutClass, _bandageCount]];
				} else {
					_warningMessages append [format ["WARNING: Loadout class '%1', subclass '%2' has very low medical supplies. Bandages [%3]", configName _mainClass, configName _loadoutClass, _bandageCount]];
				};
			};
		} forEach _loadoutClasses;
	} forEach ("!(toLower configName _x in ['base', 'example', 'example_random'])" configClasses (missionConfigFile >> "CfgXPT" >> "loadouts"));
} else {
	// XPTLoadouts not enabled. Check in-game unit loadouts.
	_auditMessages append ["XPTLoadouts disabled. Checking editor loadouts."];
	
	// Set up a hashmap to store loadout information
	private _loadoutMap = createHashMap;
	
	// Start iterating through our playable units, check if loadouts are matching between units
	// Loadouts must match *EXACTLY* for this to pass
	{
		private _unitClass = typeOf _x;
		// Check if our class is in our hashmap yet
		if (_unitClass in _loadoutMap) then {
			// Class in loadout hashmap. Compare to stored loadout
			// Loadouts stored as an array of [unit, getUnitLoadout array]
			private _storedLoadoutData = _loadoutMap get _unitClass;
			
			// Compare our loadouts
			if !((getUnitLoadout _x) isEqualTo (_storedLoadoutData select 1)) then {
				// Loadouts not equal. Add a warning
				_warningMessages append [format [
					"WARNING: Loadout mismatch for class '%1' between groups '%2' and '%3'.", 
					_unitClass, 
					groupID group (_storedLoadoutData select 0), 
					groupID group _x
				]];
			};
		} else {
			// Class is not in loadout hashmap. Store the loadout
			private _loadoutData = [
				_x,
				getUnitLoadout _x
			];
			_loadoutMap set [_unitClass, _loadoutData]
		};
	} forEach ([player] + playableUnits);
	
	// Base medical amount check
	{
		private _bandageItems = (items _x) select {toLower _x in _aceBandageClasses};
		if ((count _bandageItems) < 8) then {
			_warningMessages append [format ["WARNING: Unit '%1' in group '%2' has very low medical supplies. Bandages [%3]", typeOf _x, groupID group _x, count _bandageItems]];
		};
	} forEach ([player] + playableUnits);
};

// Ensure that we can see systemChat
showChat True;
// Write messages to systemChat

systemChat "========== BEGIN AUDIT REPORT ==========";
diag_log text "[XPT-AUDIT]: ========== BEGIN AUDIT REPORT ==========";
{
	private _list = _x;
	{
		systemChat _x;
		diag_log text format ["[XPT-AUDIT]: %1", _x];
	} forEach _list;
} forEach [_auditMessages, _warningMessages, _failMessages];

switch (true) do {
	case ((count _failMessages) > 0): {
		systemChat "FAIL: Mission does not meet audit requirements.";
		diag_log text "[XPT-AUDIT]: FAIL: Mission does not meet audit requirements.";
	};
	case ((count _warningMessages) > 0): {
		systemChat "WARNING. Please check audit details.";
		diag_log text "[XPT-AUDIT]: WARNING. Please check audit details.";
	};
	default {
		systemChat "Audit check complete";
		diag_log text "[XPT-AUDIT]: Audit check complete";
	};
};

systemChat "=========== END AUDIT REPORT ===========";
diag_log text "[XPT-AUDIT]: =========== END AUDIT REPORT ===========";