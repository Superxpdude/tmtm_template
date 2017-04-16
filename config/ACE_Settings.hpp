// ACE Settings
// Config file for defining mission-specific ACE settings
// Only uncomment the settings you want to force, leave everything else commented to avoid breaking things.

class ACE_Settings
{
	/*
	class ace_medical_amountOfReviveLives //Maximum number of revives for a player before dying
	{
		value = -1;
	};
	*/
	
	/*
	class ace_medical_increaseTrainingInLocations //Increase medical training level when near a medical station/vehicle
	{
		value = 0;
	};
	*/
	
	/*
	class ace_medical_enableOverdosing //Enables overdosing
	{
		value = 0;
	};
	*/
	
	/*
	class ace_medical_medicSetting_basicEpi //Should epinephrine require a medic to use?
	{
		value = 0;
	};
	*/
	
	/*
	class ace_medical_useLocation_basicEpi //Where can epinephrine be used?
	{
		value = 0;
		// 0 = Anywhere
		// 1 = Medical Vehicles
		// 2 = Medical Facilities
		// 3 = Vehicles + Facilities
		// 4 = Disabled
	};
	*/
	
	/*
	class ace_rearm_level //How should rearming vehicles be done?
	{
		value = 0;
		// 0 = Entire Vehicle
		// 1 = Entire Magazine
		// 2 = Amount based on weapon caliber
	};
	*/
	
	/*
	class ace_repair_engineerSetting_repair //Who can repair vehicles?
	{
		value = 0;
		// 0 = Everyone
		// 1 = Engineers + Specialists
		// 2 = Repair Specialists Only
	};
	*/
	
	/*
	class ace_repair_repairDamageThreshold //How much can untrained soldier repair vehicles?
	{
		value = 0.6;
		// Value is the damage value of the part. 0 is completely undamaged, and 1 is destroyed
	};
	*/
	
	/*
	class ace_repair_repairDamageThreshold_engineer //How much can engineers repair vehicles?
	{
		value = 0.6;
		// Value is the damage value of the part. 0 is completely undamaged, and 1 is destroyed
	};
	*/
	
	/*
	class ace_repair_engineerSetting_repair //Who can change a tire?
	{
		value = 0;
		// 0 = Everyone
		// 1 = Engineers + Specialists
		// 2 = Repair Specialists Only
	};
	*/
	
	/*
	class ace_repair_wheelRepairRequiredItems //Should toolkits be required for tire changes?
	{
		value = 0;
		// 0 = No
		// 1 = Yes
	};
	*/
	
	/*
	class ace_repair_engineerSetting_fullRepair //Who can full repair vehicles?
	{
		value = 0;
		// 0 = Anyone
		// 1 = Engineers + Specialists
		// 2 = Repair Specialists Only
	};
	*/
	
	/*
	class ace_repair_fullRepairLocation //Where can full repairs be performed?
	{
		value = 0;
		// 0 = Anywhere
		// 1 = Repair Vehicles
		// 2 = Repair Facilities
		// 3 = Repair Vehicles + Facilities
		// 4 = Disabled
	};
	*/
	
	/*
	class ace_weather_enableServerController //Enable weather sync?
	{
		value = 1;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_weather_useACEWeather //Enable ACE weather?
	{
		value = 0;
		// 0 = Disabled
		// 1 = Enabled
		// Disable this if you're going to manually change the weather
	};
	*/
	
	/*
	class ace_weather_syncRain //Synchronizes rain states
	{
		value = 1;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_weather_syncWind //Synchronizes wind states
	{
		value = 1;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_weather_syncMisc //Syncronizes other weather
	{
		value = 1;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_zeus_zeusAscension //Display message when a player becomes zeus
	{
		value = 0;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_zeus_zeusBird //Create a bird near the zeus camera
	{
		value = 0;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_zeus_remoteWind //Plays a wind sound when zeus remote controls a unit
	{
		value = 0;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
	
	/*
	class ace_zeus_radioOrdnance //Plays a radio message when zeus calls in ordnance (mortars, artillery, etc)
	{
		value = 0;
		// 0 = Disabled
		// 1 = Enabled
	};
	*/
};