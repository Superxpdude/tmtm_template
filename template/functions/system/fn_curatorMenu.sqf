/*
	XPT_fnc_curatorMenu
	Author: Superxpdude
	Handles setting up the curator menu
	Only runs if the player is a curator
	
	Parameters: None
		
	Returns: Nothing
*/

// Do not run on a dedicated server or headless client
if (!hasInterface) exitWith {};
// Wait until the player exists
waitUntil {!isNull player};
// Check the kind of player that we're dealing with. Only run if it's a zeus player.
if (!(player isKindOf "VirtualMan_F")) exitWith {};

// Create our briefing section
player createDiarySubject ["zeusmenu", "Zeus Menu"];
// Add the default debug actions
player createDiaryRecord ["zeusmenu", ["Debug",
	"<executeClose expression='[zeus_Unit, zeus_Module] remoteExec [""XPT_fnc_debugCuratorFix"", 2]'>Fix Curator Module</execute><br/>"
]];