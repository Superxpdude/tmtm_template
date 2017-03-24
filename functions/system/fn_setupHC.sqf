// Function for setting up the headless client
if ((_this select 0) == 0) exitWith {};
[] spawn {
	// Wait until after the briefing
	sleep 1;
	// Exit if we don't have a headless client
	if (isNil "hc") exitWith{};
	// Let all of the clients know that we have a headless client running
	hcActive = true;
	publicVariable "hcActive";
	hcClient = owner hc;
	publicVariable "hcClient";

	// Move all non-player groups to the headless client
	{
		if (!(isPlayer (leader _x))) then {
			_x setGroupOwner hcClient;
		};
	} forEach allGroups;

	// Add an event handler that adds all zeus spawned units to the HC
	{_x addEventHandler ["CuratorObjectPlaced",
		{[(group (_this select 1)),hcClient] remoteExec ["SXP_fnc_transferGroup", 2];}];
	} forEach allCurators;
};