// Script to handle the briefing-based zeus menu
// This is used by default to provide a zeus player with some additional debug functionality
// However, custom entries can be added into the menu for manually triggering tasks, playing music, ending the mission, etc.

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
	"<executeClose expression='[zeus_Unit, zeus_Module] remoteExec [""SXP_fnc_fixCurator"", 2]'>Fix Curator Module</execute><br/>"
]];

// Add any mission specific sections below. Replace the examples with your own menu entries
// Uncomment the section below to activate
/*
player createDiaryRecord ["zeusmenu", ["Zeus Actions",
	"<executeClose expression='[""majorVictory""] call SXP_fnc_endMission'>End Mission: Major Victory</execute><br/>
	<executeClose expression='[""minorVictory""] call SXP_fnc_endMission'>End Mission: Minor Victory</execute><br/>
	<executeClose expression='[""missionFailed""] call SXP_fnc_endMission'>End Mission: Mission Failed</execute><br/>
]];
*/