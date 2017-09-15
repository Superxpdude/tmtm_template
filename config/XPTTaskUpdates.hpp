// Task updates
// Config based method for updating task status
/*
	CONFIG EXAMPLE
	The following config is an example of how to task updates should be written
	
	class example	// Config class. Used when calling XPT_fnc_updateTask. Needs to be unique.
	{
		briefings[] = {};			// Briefings to be created. Should be an array of strings that match XPTBriefings.hpp briefing classes. These are displayed in reverse order in game.
		code = "";					// Task update code in string form. This is the last part to get executed when the task update is called.
		
		// The following values should be arrays comprised of strings of task names.
		// These tasks need to exist beforehand. XPT_fnc_updateTask will NOT create new tasks unless specified in the code portion.
		tasksCreated[] = {};			// Tasks to be set to the "created" state
		tasksAssigned[] = {};		// Tasks to be set to the "assigned" state
		tasksSucceeded[] = {};		// Tasks to be set to the "succeeded" state
		tasksFailed[] = {};			// Tasks to be set to the "failed" state
		tasksCancelled[] = {};		// Tasks to be cancelled.
	};
	
	This code is only ever executed on the server. If you need to do something like creating a diary record, you need to remoteExec it to any clients that would need it.
*/
class taskUpdates
{
	// Task update configs go in this section.
	
	
	
};
