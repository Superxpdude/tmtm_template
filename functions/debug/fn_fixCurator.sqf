// Function to fix the zeus module (assuming black screen bug happens).
// Only to be run on the server

if (!isServer) exitWith {_this remoteExec ["SXP_fnc_fixCurator", 2];};

unassignCurator (_this select 1);
sleep 3;
(_this select 0) assignCurator (_this select 1);