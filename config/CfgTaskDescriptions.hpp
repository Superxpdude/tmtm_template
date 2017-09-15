// Task Descriptions
// Can be used for moving task descriptions from script files to configs


// Create new classes under here. BIS_fnc_taskCreate will use either the class passed as the description parameter (in string format)
// The following would be loaded by setting the description to "example";
// If the description is blank (""), then the task ID will be used automatically
class example
{
	title = "Example Task Title";					// Title of task. Displayed as the task name
	description = "Example Task Description";		// Description of task. Additional details displayed when the task is selected on the map screen.
	marker = "";									// Task marker. Leave blank
};