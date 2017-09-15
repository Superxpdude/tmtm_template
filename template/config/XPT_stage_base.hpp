// XPT_stage_base.hpp
// Base stage config for the template.
// User created stages should always inherit from this stage, or another user stage.

class stage_base
{
	displayname = "Default Stage"; // Human readable name for the stage.
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
		// TODO: Fill this with default loadouts for player classes
	};
};