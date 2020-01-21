// Mission parameters
// Available in mission lobby
// TEMPLATE SPECIFIC PARAMETERS. DO NOT EDIT THIS FILE DIRECTLY UNLESS YOU KNOW WHAT YOU'RE DOING!

// Parameter classes
class header_ace_medical
{
	title = "===== ACE3 - Medical Settings =====";
	values[] = {0};
	texts[] = {""};
	default = 0;
};
class xpt_medical_level
{
	title = "ACE3 - Medical Level";
	XPT_CBA_multiSetting = 1;
	values[] = {0,1,2};
	texts[] = {"Standard", "Realistic", "Custom"};
	default = XPT_ACE3_MEDICALLEVEL;
	XPT_paramArray[] = {
		// Standard medical
		{
			{"ace_medical_limping",1},
			{"ace_medical_fractures",0},
			{"ace_medical_treatment_advancedDiagnose",1},
			{"ace_medical_treatment_advancedBandages",0},
			{"ace_medical_treatment_clearTraumaAfterBandage",1},
			{"ace_medical_treatment_advancedMedication",1},
			{"ace_medical_treatment_woundReopening",0}
		},
		// Realistic medical
		{
			{"ace_medical_limping",2},
			{"ace_medical_fractures",1},
			{"ace_medical_treatment_advancedDiagnose",1},
			{"ace_medical_treatment_advancedBandages",1},
			{"ace_medical_treatment_clearTraumaAfterBandage",0},
			{"ace_medical_treatment_advancedMedication",1},
			{"ace_medical_treatment_woundReopening",1}
		},
		// Custom
		{}
	};
};
class ace_medical_fatalDamageSource
{
	title = "ACE3 - Fatal Damage Source";
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Only large hits to vital organs","Sum of trauma","Either"};
	default = XPT_ACE3_FATALDAMAGESOURCE;
};
class ace_medical_statemachine_fatalInjuriesPlayer
{
	title = "ACE3 - Player Fatal Injuries";
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Always", "Only in Cardiac Arrest", "Never"};
	#ifdef XPT_DEFINEPVP
		default = XPT_ACE3_PLAYERFATAL_PVP;
	#else
		default = XPT_ACE3_PLAYERFATAL_COOP;
	#endif
};
class ace_medical_statemachine_cardiacArrestTime
{
	title = "ACE3 - Cardiac Arrest Timer";
	XPT_CBA_setting = 1;
	values[] = {30,60,90,120,180,240,300};
	texts[] = {"30 seconds", "60 seconds", "90 seconds", "2 minutes", "3 minutes", "4 minutes", "5 minutes"};
	default = XPT_ACE3_CARDARREST_TIMER;
};
class ace_medical_playerDamageThreshold
{
	title = "ACE3 - Player Health Multiplier";
	XPT_CBA_setting = 1;
	XPT_modifier = "%1/100";
	values[] = {50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200};
	texts[] = {"50%","60%","70%","80%","90%","100%","110%","120%","130%","140%","150%","160%","170%","180%","190%","200%"};
	default = XPT_ACE3_PLAYERDAMAGETHRESHOLD;
};
class ace_medical_AIDamageThreshold
{
	title = "ACE3 - AI Health Multiplier";
	XPT_CBA_setting = 1;
	XPT_modifier = "%1/100";
	values[] = {50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200};
	texts[] = {"50%","60%","70%","80%","90%","100%","110%","120%","130%","140%","150%","160%","170%","180%","190%","200%"};
	default = XPT_ACE3_AIDAMAGETHRESHOLD;
};
class header_acex_settings
{
	title = "===== ACEX Settings =====";
	values[] = {0};
	texts[] = {""};
	default = 0;
};
class acex_viewrestriction_mode
{
	title = "ACEX - View Restriction";
	//ACE_setting = 1;
	XPT_CBA_setting = 1;
	values[] = {0,1,2,3};
	texts[] = {"Disabled","Forced First-Person","Forced Third-Person","Selective (Follows rules below)"};
	#ifdef XPT_DEFINEPVP
		default = XPT_ACEX_VIEWRESTRICTION_PVP;
	#else
		default = XPT_ACEX_VIEWRESTRICTION_COOP;
	#endif
};
class acex_viewrestriction_modeSelectiveFoot
{
	title = "ACEX - View Restriction Selective (On foot)";
	//ACE_setting = 1;
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Disabled","Forced First-Person","Forced Third-Person"};
	default = XPT_ACEX_VIEWRESTRICTION_FOOT;
};
class acex_viewrestriction_modeSelectiveLand
{
	title = "ACEX - View Restriction Selective (Land Vehicles)";
	//ACE_setting = 1;
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Disabled","Forced First-Person","Forced Third-Person"};
	default = XPT_ACEX_VIEWRESTRICTION_LAND;
};
class acex_viewrestriction_modeSelectiveAir
{
	title = "ACEX - View Restriction Selective (Air Vehicles)";
	//ACE_setting = 1;
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Disabled","Forced First-Person","Forced Third-Person"};
	default = XPT_ACEX_VIEWRESTRICTION_AIR;
};
class acex_viewrestriction_modeSelectiveSea
{
	title = "ACEX - View Restriction Selective (Sea Vehicles)";
	//ACE_setting = 1;
	XPT_CBA_setting = 1;
	values[] = {0,1,2};
	texts[] = {"Disabled","Forced First-Person","Forced Third-Person"};
	default = XPT_ACEX_VIEWRESTRICTION_SEA;
};
class header_mission_settings
{
	title = "===== Template Settings =====";
	values[] = {0};
	texts[] = {""};
	default = 0;
};
class XPT_map_markers
{
	title = "XPT - Enable group tracking on map";
	values[] = {0,1};
	texts[] = {"Disabled", "Enabled"};
	default = XPT_MAPMARKERS;
	isGlobal = 0;
	function = "XPT_fnc_mapMarkersServer";
};
class XPT_headlessclient
{
	title = "XPT - Enable Headless Client support";
	values[] = {0,1};
	texts[] = {"Disabled", "Automatic"};
	default = 1;
	isGlobal = 0;
};
class XPT_debugMode
{
	title = "XPT - Enable debug mode";
	values[] = {0,1};
	texts[] = {"Disabled", "Enabled"};
	default = XPT_DEBUGMODE;
};
