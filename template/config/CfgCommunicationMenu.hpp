// Communication Menu
// Defines custom comm menu entries for the template
// TEMPLATE SPECIFIC FUNCTIONS. DO NOT EDIT THIS FILE DIRECTLY UNLESS YOU KNOW WHAT YOU'RE DOING!

class xpt_jipTeleportComm	// Activates the JIP teleporter.
{
	text = "Teleport to Squad";
	submenu = "";
	expression = "[player] call XPT_fnc_jipTeleport;";
	icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa";
	cursor = "";
	enable = "1";
	removeAfterExpressionCall = 1;
};