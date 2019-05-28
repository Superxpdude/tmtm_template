// Mission briefings
// Config method of creating custom briefings
/*
	CONFIG BRIEFING EXAMPLE
	The following config is an example of how your briefing should be written
	
	class example	// Config class. Used when calling XPT_fnc_briefingCreate. Needs to be unique.
	{
		category = "Diary";		// Category that the briefing goes in. Use "Diary" for the default briefing class
		entryName = "Title";	// Briefing title. This is usually something like "Situation", "Mission", "Assets", etc.
		entryText = "Text";		// Briefing text. Formatted as structured text, contains the contents of your briefing.
		onStart = 1;			// Briefing on start. Determines if the briefing should be created upon mission start. Set to 0 to disable.
		sides[] = {0,1,2,3};	// Briefing sides. Determines which sides will receive the briefing message on mission start. Good for TvTs.
	};
	
	Briefings will appear ordered from bottom to top as they're listed here.
	This is because the game adds new briefings to the top of the list, and the template adds the briefings from top to bottom.
*/

class briefings
{
	// Uncomment the briefings below if you intend to use them for your mission.
	/*
	class assets	// Example assets briefing. Should include a list of all friendly vehicle assets available.
	{
		category = "Diary";
		entryName = "Assets";
		entryText = "Example Assets List. REPLACE BEFORE RUNNING THE MISSION.<br/> - 1x Car<br/> - 1x Tank<br/> - 1x Boat<br/> - 1x Plane";
		onStart = 1;
		sides[] = {0,1,2,3};
	};
	class mission	// Example mission briefing. Should include a brief overview of the player's tasks.
	{
		category = "Diary";
		entryName = "Mission";
		entryText = "Example Mission Briefing. REPLACE BEFORE RUNNING THE MISSION<br/>. We need to get the bad guy.";
		onStart = 1;
		sides[] = {0,1,2,3};
	};
	class situation	// Example situation briefing. Should include a bit of backstory to your mission.
	{
		category = "Diary";
		entryName = "Situation";
		entryText = "Example Situation. REPLACE BEFORE RUNNING THE MISSION<br/>. The bad guy did a bad thing. We need to stop him!";
		onStart = 1;
		sides[] = {0,1,2,3};
	};
	*/
};