// Mission parameters
// Available on mission lobby
// https://community.bistudio.com/wiki/Arma_3_Mission_Parameters

{
	class ace_medical_level
    {
        title = "ACE3 Medical Level";
        ACE_setting = 1;
        values[] = {1,2};
        texts[] = {"Basic", "Advanced"};
        default = 1;
    };
    class ace_medical_enableRevive
    {
        title = "Enable ACE3 Revive";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"No", "Yes"};
        default = 1;
    };
    class ace_medical_enableUnconsciousnessAI
    {
        title = "AI Unconsciousness Setting";
        ACE_setting = 1;
        values[] = {0,1,2};
        texts[] = {"Instant Death", "50/50", "Always go unconscious first"};
        default = 1;
    };
	class map_markers
	{
		title = "Enable group tracking on map";
		values[] = {0,1};
		texts[] = {"Disabled", "Enabled"};
		default = 1;
		isGlobal = 0;
		function = "SXP_fnc_mapMarkers";
	};
	class headlessclient
	{
		title = "Enable Headless Client support";
		values[] = {0,1};
		texts[] = {"Disabled", "Automatic"};
		default = 1;
		isGlobal = 0;
		function = "SXP_fnc_setupHC";
	};
};