// XPTItemCargos.hpp
// Used for defining ammo box and vehicle item cargos
// XPTVehicleLoadouts can pull definitions from here in order to supply vehicles
// Supports sub-class randomization, if a definition has multiple sub-classes, the script will automatically select one of them to apply to the vehicle/box.

/* 
	Randomization support
	
	--- Sub-class randomization --- 
	
	Any itemCargos class can define items through a sub-class instead of in the main class.
	In this case, the script will pick one of the sub-classes at random to apply to the object.
	The names of the sub-classes do not matter.
	
	The following example will select one of "box1" or "box2" when the "MyAmmoBox" class is called.
	The names of the subclasses don't matter, and they can be named whatever you want them to be.
	
	class itemCargos
	{
		class MyAmmoBox
		{
			class box1
			{
				items[] = {};
			};
			class box2
			{
				items[] = {};
			};
		};
	};
	
	
	--- Per-item randomization ---
	
	Any item can have the quantity changed from a fixed value, to a randomized value.
	By creating an array of three numbers instead of a single one, the itemCargo script will randomly select a quantity using the provided numbers.
	
	Example:
	
	class MyAmmoBox
	{
		items[] = {"FirstAidKit", {1,3,5}}; // Spawns a minimum of 1, a maximum of 5, and an average of 3
	};

*/
class itemCargos
{
	class example
	{
		// Array containing sub-arrays of items to add
		// Sub-arrays must include an item classname, and a quantity
		// The following would add 5 first aid kits to the inventory of the object
		items[] = {
			{"FirstAidKit", 5},
			{"FirstAidKit", {1,3,5}}
		};
		// Array of items that will only be added when ACE basic medical is being used
		itemsBasicMed[] = {
			{"FirstAidKit", 5},
			{"FirstAidKit", {1,3,5}}
		};
		// Array of items that will only be added when ACE advanced medical is being used
		itemsAdvMed[] = {
			{"FirstAidKit", 5},
			{"FirstAidKit", {1,3,5}}
		};
	};
};