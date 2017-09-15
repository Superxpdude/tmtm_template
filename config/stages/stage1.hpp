// XPT Stages - Stage 1
// Stage config for the XPT template
// Used if you're going to have a mission that changes loadouts or such partway through
// Stages should ALWAYS inherit from the base stage, or another use created stage
// Stage 1 is the default stage, and will automatically be activated upon mission start. This can be changed in description.ext

class stage1: stage_base
{
	displayname = "Stage 1"; // Human readable name for the stage.
	initScript = ""; // String containing code to be compiled then executed when the stage is activated. Only executed on the server.
	endScript = ""; // String containing code to be compiled then executed when the stage is terminated. Only executed on the server.
	
	// Stage respawn settings do not work at this time.
	// Respawn Templates
	// Extra respawn templates to be executed when this stage is active
	/* 
	respawnTemplates[] = {};
	respawnTemplatesWest[] = {};
	respawnTemplatesEast[] = {};
	respawnTemplatesGuer[] = {};
	respawnTemplatesCiv[] = {};
	respawnTemplatesVirtual[] = {};
	
	respawnDelay = -1; // Custom respawn delay for this stage. -1 will use the description.ext value.
	*/
	
	// Player unit loadouts for this stage.
	class loadouts
	{
		// Stage-specific loadouts can go in here. The template will fall back on the old XPTLoadouts.hpp if a loadout is not found in this class
	};
};