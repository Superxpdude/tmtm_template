// Notifications system
// Allows consistent looking mission notifications to be displayed (same appearance as task notifications)
// https://community.bistudio.com/wiki/Notification
// Arguments can be passed from BIS_fnc_showNotification, use the percent symbol to signify a value defined by an argument (similar to the format command)

class example
{
	title = ""; // Tile displayed as text on black background. Filled by arguments.
	iconPicture = ""; // Small icon displayed in left part. Colored by "color", filled by arguments.
	iconText = ""; // Short text displayed over the icon. Colored by "color", filled by arguments.
	description = ""; // Brief description displayed as structured text. Colored by "color", filled by arguments.
	color[] = {1,1,1,1}; // Icon and text color
	duration = 5; // How many seconds will the notification be displayed
	priority = 0; // Priority; higher number = more important; tasks in queue are selected by priority
	difficulty[] = {}; // Required difficulty settings. All listed difficulties has to be enabled
};