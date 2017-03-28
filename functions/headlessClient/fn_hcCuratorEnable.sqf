// Function to toggle enabling zeus-spawned units to the headless client

// Change the value of the zeus-enabled parameter
sxp_hc_zeusEnable = (_this select 0);
// Broadcast the change to all clients
publicVariable "sxp_hc_zeusEnable";
// Notify the zeus client that the status has been changed
if (_this select 0) then {
	systemChat "SXP-Headless: Curator unit transfer enabled";
} else {
	systemChat "SXP-Headless: Curator unit transfer disabled";
};