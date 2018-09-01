// XPTVehicleSetup.hpp
// Used for defining vehicle configurations regarding loadouts, pylons, and cargo
// The template can be configured to automatically assign vehicle loadouts on mission start, vehicle respawn, and zeus spawn.

// Currently a placeholder
class vehicleSetup
{
	// Classes will automatically be applied if they match a valid vehicle classname
	class example
	{
		itemCargo = ""; // String name of an XPTItemCargos class to apply to the cargo of the vehicle.
		
		// Array of pylons, and their associated magazines. Pylon names are specific to the vehicle
		// Sub-arrays use the following format
		// - Pylon name/index, obtained from the vehicle's pylon config
		// - Pylon magazine, classname of the pylon magazine to be added
		// - (Optional) Force, 0/1 switch, forces the magazine even if the pylon doesn't support it. Defaults to 0 (false) if undefined
		// - (Optional) Turret, array pointing to the turret that will receive the weapon. Use an empty array {} for the pilot. Defaults to the gunner's turret.
		pylons[] = {
			{"pylon1", "example_pylon_mag",0,{}}
		};
		
		// Array containing information regarding vehicle turrets.
		// NOTE: If weapons or magazines are defined in turretConfigs, all existing weapons and magazines will be removed from that turret. Use empty arrays if you want to preserve turret armament.
		// Do not use the weapons or magazines config for weapons associated with pylons.
		// It is strongly recommended that you define all pylons when using the manual weapon and magazine overrides.
		turretConfigs[] = {
			{
				{0}, // Turret path. This changes depending on the vehicle, driver is usually {-1}
				{"weapon1","weapon2"}, // Weapons to add to the specific turret. Use an empty array {} if no weapons will change.
				{{"magazine1",1},{"magazine2",5}}, // Magazines to add to the specific turret. Use an empty array {} if no magazines will change.
				0 // Lock status of the turret. 0 = Unlocked, 1 = Locked
			};
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