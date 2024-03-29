// Notifications system
// Notifications for the template
// TEMPLATE SPECIFIC PARAMETERS. DO NOT EDIT THIS FILE DIRECTLY UNLESS YOU KNOW WHAT YOU'RE DOING!

class XPT_debugMode // Debug mode notification. Displays when a mission is started with debug mode enabled.
{
	title = "Debug Mode";
	iconPicture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
	iconText = "";
	description = "Debug mode is enabled. Some mission parameters may be changed.";
	duration = 10;
	priority = 100000;
};

class XPT_devWarning // Dev version notification. Displays when a mission is using a dev version of the template.
{
	title = "TEMPLATE DEV VERSION";
	iconPicture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
	iconText = "";
	description = "Please download the template from the releases page!";
	color[] = {1,0.65,0,1};
	duration = 15;
	priority = 100000;
};

class XPT_jipTeleAvail
{
	title = "JIP Teleport to Squad Available";
	iconPicture = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa";
	description = "Open Communication Menu to teleport.";
	duration = 10;
	priority = 1000;
};

class XPT_jipTeleFail
{
	title = "Could Not Find Valid Teleport Target";
	iconPicture = "\A3\ui_f\data\map\mapControl\taskIconFailed_ca.paa";
	iconText = "";
	description = "Squad may be dead. Ask an Admin or Zeus for teleport if needed.";
	duration = 10;
	priority = 1000;
};