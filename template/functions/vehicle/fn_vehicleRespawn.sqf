/*
	XPT_fnc_vehicleRespawn
	Author: Superxpdude
	Handles restoring pylons, inventory, and vehicle textures to a respawned vehicle.
	Only executed on the server. Will execute commands as local where required.
	Designed to be called directly from the "Expression" field of a vehicle respawn module.
	
	Parameters:
		0: Object - New vehicle
		1: Object - Old vehicle
		
	Returns: Bool
		True if the vehicle was configured correctly
		False if there was an error configuring the vehicle
*/

#include "script_macros.hpp"

// Only run on the server
if (!isServer) exitWith {};