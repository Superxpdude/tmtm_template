// XPTVehicleSetup.hpp
// Used for defining vehicle configurations regarding loadouts, pylons, and cargo
// The template can be configured to automatically assign vehicle loadouts on mission start, vehicle respawn, and zeus spawn.

// Currently a placeholder
class vehicleSetup
{
	// Classes will automatically be applied if they match a valid vehicle classname
	class example
	{
		itemCargo = ""; // String name of an XPTItemCargos class to apply to the cargo of the vehicle
		
		// Array of pylons, and their associated magazines. Pylon names are specific to the vehicle
		// Sub-arrays use the following format
		// - Pylon name/index, obtained from the vehicle's pylon config
		// - Pylon magazine, classname of the pylon magazine to be added
		// - Force, true/false switch, forces the magazine even if the pylon doesn't support it. Defaults to false if undefined
		// - Turret, array pointing to the turret that will receive the weapon. Use an empty array {} for the pilot
		pylons[] = {
			{"pylon1", "example_pylon_mag"}
		};
		
		// Array containing information regarding vehicle turrets.
		// NOTE: If a turret is defined in turretConfigs, all existing weapons and magazines will be removed from the turret
		turretConfigs[] = {
			{
				{0}, // Turret path. This changes depending on the vehicle, driver is usually {-1}
				{"weapon1","weapon2"}, // Weapons to add to the specific turret
				{"magazine1","magazine2"} // Magazines to add to the specific turret
			};
		};
		
		// Array of turret paths that should be locked. Useful for if you want to limit the capacity of a vehicle, or if you're using an animation to remove a turret
		turretLocks[] = {
			{0},
			{1}
		};
		
		// Datalink. Must be an array of three numerical values. -1 = No Change, 0 = Disabled, 1 = Enabled. Sets the datalink status of the vehicle.
		// Arrays must use the following order
		// - Report own position
		// - Report target position
		// - Receive target position
		datalink[] = {
			1,
			1,
			1
		};
	};
};