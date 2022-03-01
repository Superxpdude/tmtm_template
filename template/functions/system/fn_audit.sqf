/*
	XPT_fnc_audit
	Author: Superxpdude
	Performs rudimentary checks on a mission to determine if it would pass a TMTM audit.
	
	Parameters:
		No parameters. Checks entire mission.
		
	Returns: Nothing
*/

// Do not run if our mission was not run from the editor
if !(is3DEN or is3DENPreview) exitWith {};

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


// ---------------------------------------------------
// --------------- BEGIN MISSION CHECK ---------------
// ---------------------------------------------------

// Get mission information
private _missionType = [(getMissionConfig "Header" >> "gameType") call BIS_fnc_getCfgData] param [0, "", [""]];
private _isPVP = if (toLower (_missionType) == "tvt") then {True} else {False};
private _respawnTimer = getMissionConfigValue ["respawnDelay", 1e10];

// Basic validation on the briefingName
private _briefingNameType = ((getMissionConfigValue ["briefingName", ""]) splitString " ") select 0;
switch (true) do {
	case (isNil "_briefingNameType"): {
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

if (_isPVP) then {
	// PVP mission
	if (_viewRestriction != 1) then {
		_warningMessages append ["WARNING: PvP missions are recommended to use first-person view restrictions"];
	};
} else {
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
};

// Medical preset
private _medicalPreset = [(getMissionConfig "params" >> "xpt_medical_level" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];

if (_medicalPreset != 0) then {
	_failMessages append ["ERROR: Mission does not use the ""Standard"" medical preset."];
};

// Player fatal injuries / fatal damage source
private _fatalInjuries = [(getMissionConfig "params" >> "ace_medical_statemachine_fatalInjuriesPlayer" >> "default") call BIS_fnc_getCfgData] param [0, 1, [0]];
private _fatalDamageSource = [(getMissionConfig "params" >> "ace_medical_fatalDamageSource" >> "default") call BIS_fnc_getCfgData] param [0, 0, [0]];
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

// Check respawn timer
if (_respawnTimer > 1800) then {
	_warningMessages append ["WARNING: Mission has respawns disabled. Please verify that the mission will take less than one hour to complete."];
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

// Ensure that we can see systemChat
showChat True;
// Write messages to systemChat

systemChat "Begin audit report";
{
	private _list = _x;
	{
		systemChat _x;
	} forEach _list;
} forEach [_auditMessages, _warningMessages, _failMessages];

switch (true) do {
	case ((count _failMessages) > 0): {
		systemChat "FAIL: Mission does not meet audit requirements.";
	};
	case ((count _warningMessages) > 0): {
		systemChat "WARNING. Please check audit details.";
	};
	default {
		systemChat "Audit check complete";
	};
};