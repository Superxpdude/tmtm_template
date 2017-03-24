// Function to transfer group ownership to another machine
// Only to be run on the server
if (!isServer) exitWith {_this remoteExec ["SXP_fnc_transferGroup", 2];};

(_this select 0) setGroupOwner (_this select 1);