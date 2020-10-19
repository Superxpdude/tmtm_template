// Script to handle initial mission briefings
// General guidelines would be to include briefings for the following
// Situation, Mission, and Assets
// Briefings are listed in the opposite order that they are written below. New diaryRecords are always placed at the top of the list.
// https://community.bistudio.com/wiki/createDiaryRecord

//player createDiaryRecord ["Diary", ["Assets", "Example Mission Assets"]];
//player createDiaryRecord ["Diary", ["Mission", "Example Mission Briefing"]];
//player createDiaryRecord ["Diary", ["Situation", "Example Situation Briefing"]];

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
