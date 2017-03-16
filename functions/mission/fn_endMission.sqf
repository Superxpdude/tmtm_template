// Function to handle ending the mission on all clients
// Call the function with one of the parameters below to handle ending the mission.
// Any code can be inserted within the switch fields. Can also be used for advanced ending scenarios
// Example: TvT where both sides see different endings.

// Only run on the server
if (!isServer) exitWith {};

// Begin the switch section
switch (toLower (_this select 0)) do {
	case "win": {
		// Call the below mission ending on all clients.
		// Below example is for mission success.
		["example", true] remoteExec ["BIS_fnc_endMission", 0];
	};
	case "fail": {
		// Below example is for mission failure. (Displays different text type and ending music)
		["example", false] remoteExec ["BIS_fnc_endMission", 0];
	};
};