// initServer.sqf
// Executes only on the server at mission start
// No parameters are passed to this script

// Create a list of mission objects that should not be curator editable
XPT_blacklistedMissionObjects = [];

// Call the template initServer function
[] call XPT_fnc_initServer; // DO NOT CHANGE THIS LINE

// Call the script to handle initial task setup
[] execVM "scripts\tasks.sqf";

// Add any mission specific code after this point