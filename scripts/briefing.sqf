// Script to handle initial mission briefings
// General guidelines would be to include briefings for the following
// Situation, Mission, and Assets
// Briefings are listed in the opposite order that they are written below. New diaryRecords are always placed at the top of the list.
// https://community.bistudio.com/wiki/createDiaryRecord

/*
	===== TO CREATE A BASIC BRIEFING =====
	The following code will add a "basic" briefing to all units in the mission

	player createDiaryRecord ["Diary", ["Assets", "Example Mission Assets"]];
	player createDiaryRecord ["Diary", ["Mission", "Example Mission Briefing"]];
	player createDiaryRecord ["Diary", ["Situation", "Example Situation Briefing"]];


	===== TO CREATE A SIDE-SPECIFIC BRIEFING =====
	The following code will add a briefing *only* to a certain side
	In this example, a briefing will be created that is only visible to BLUFOR players
	UNLESS YOUR MISSION HAS MULTIPLE PLAYER SIDES. YOU DO NOT NEED THIS CODE.
	
	if ((side player) == west) then {
		player createDiaryRecord ["Diary", ["Mission", "BLUFOR mission notes go here"]];
	};
	
	
	===== TO CREATE A ZEUS-SPECIFIC BRIEFING =====
	The following code will add a briefing *only* to player zeus units.
	
	if (player isKindOf "VirtualCurator_F")then {
		player createDiaryRecord ["Diary", ["Zeus Notes", "Zeus notes go here"]];
	};
	
	
	===== NOTES =====
	Keep in mind that even with these if-statements, briefings will still appear in *reverse order from which they are written*
	This means if you want an extra note for a specific side that goes at the bottom of the briefing, that briefing should go at the top of this file.
*/

player createDiaryRecord ["Diary", ["Assets", "Example Asset List:<br/>
	- 1x Tank<br/>
	- 4x Car<br/>
	- 4x Truck<br/>
	- 2x Helicopter
"]];

player createDiaryRecord ["Diary", ["Intel",
"Example Intel Briefing"
]];


player createDiaryRecord ["Diary", ["Mission",
"Example Mission Briefing."
]];

player createDiaryRecord ["Diary", ["Situation",
"Example Situation Briefing.
<br/>Now with new lines."
]];
