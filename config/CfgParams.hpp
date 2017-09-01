// Mission parameters
// Available on mission lobby
// https://community.bistudio.com/wiki/Arma_3_Mission_Parameters
class params
{
	class header_ace_medical
	{
		title = "===== ACE3 - Medical Settings =====";
		values[] = {0};
		texts[] = {""};
		default = 0;
	};
	// Don't change anything other than the default value
	class ace_medical_level
	{
		title = "ACE3 - Medical Level";
		ACE_setting = 1;
		values[] = {1,2};
		texts[] = {"Basic", "Advanced"};
		default = 1;
	};
	// Don't change anything other than the default value
	class ace_medical_preventInstaDeath
	{
		title = "ACE3 - Prevent Instant Death";
		ACE_setting = 1;
		values[] = {0,1};
		texts[] = {"Disabled", "Enabled"};
		default = 1;
	};
	// Don't change anything other than the default value
	class ace_medical_enableRevive
	{
		title = "ACE3 - Enable Revive";
		ACE_setting = 1;
		values[] = {0,1};
		texts[] = {"Disabled", "Enabled"};
		default = 1;
	};
	// Don't change anything other than the default value
	class ace_medical_maxReviveTime
	{
		title = "ACE3 - Revive Bleedout Timer";
		ACE_setting = 1;
		values[] = {30,60,90,120,180,240,300};
		texts[] = {"30 seconds", "60 seconds", "90 seconds", "2 minutes", "3 minutes", "4 minutes", "5 minutes"};
		default = 300;
	};
	// Don't change anything other than the default value
	class ace_medical_enableUnconsciousnessAI
	{
		title = "ACE3 - AI Unconsciousness";
		ACE_setting = 1;
		values[] = {0,1,2};
		texts[] = {"Disabled", "50/50", "Enabled"};
		default = 0;
	};
	class header_mission_settings
	{
		title = "===== Mission Settings =====";
		values[] = {0};
		texts[] = {""};
		default = 0;
	};
	// Don't change anything other than the default value
	class map_markers
	{
		title = "SXP - Enable group tracking on map";
		values[] = {0,1};
		texts[] = {"Disabled", "Enabled"};
		default = 1;
		isGlobal = 0;
		function = "SXP_fnc_mapMarkers";
	};
	// Don't change anything in this class
	class headlessclient
	{
		title = "SXP - Enable Headless Client support";
		values[] = {0,1};
		texts[] = {"Disabled", "Automatic"};
		default = 1;
		isGlobal = 0;
	};
};