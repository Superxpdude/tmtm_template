/*
	XPT_fnc_curatorFailsafe
	Author: Superxpdude
	Failsafe function to automatically resolve situations where curator assignment fails on a dedicated server (player ends up with a black screen and no zeus interface).
	
	Parameters: Designed to be called directly from a "Local" event handler
		
	Returns: Nothing
*/

#include "script_macros.hpp"

// Only to be run on the server
if (!isServer) exitWith {};

// Grab our parameters
params ["_logic", "_local"];

if (!_local) then {
	// If the module is transferred to a client, start the failsafe check
	sleep 10; // Give the module some time to initialize
	private _logicOwner = owner _logic;
	
	// Check if the curator has been assigned successfully
	private _unit = getAssignedCuratorUnit _logic;
	private _assignedLogic = getAssignedCuratorLogic _unit;
	
	if (_assignedLogic != _logic) then {
		// If the logic has not been assigned successfully, initiate the failsafe.
		// Send a message to the client letting them know that the issue is being fixed.
		["Curator module failsafe activated. Please stand by."] remoteExec ["systemChat", _owner];
		
		// If ZEN (Zeus Enhanced) is installed. Wait 15 seconds to see if their failsafe will fix it
		if (isClass (configfile >> "CfgMods" >> "zen_modules")) then {
			sleep 10;
		};
		
		// Double check in case ZEN managed to fix it
		if ((getAssignedCuratorLogic _unit) == _logic) exitWith {};
		
		// Start the failsafe
		["Executing curator module failsafe"] remoteExec ["systemChat", _owner];
		unassignCurator _logic;
		
		// Wait until the module has been unassigned
		waitUntil {isNull (getAssignedCuratorUnit _logic)};
		
		// Start our failsafe loop
		private _attempt = 0;
		while {isNull (getAssignedCuratorUnit _logic)} do {
			_unit assignCurator _logic;
			[format ["Attempting to re-establish curator module connection. Attempt: %1",_attempt]] remoteExec ["systemChat", _owner];
			_attempt = _attempt + 1;
			sleep 5;
			if (_attempt > 20) exitWith {
				[format ["Cancelling curator reassignment for [%1|%2] after too many attempts: %3",_unit,_logic,_attempt]] remoteExec ["systemChat", _owner];
			};
		};
		
		// Check if the unit is correctly assigned to the curator module
		private _newUnit = getAssignedCuratorUnit _logic;
		_assignedLogic = getAssignedCuratorLogic _unit;
		
		if (_assignedLogic == _logic) then {
			["Curator module connection re-established."] remoteExec ["systemChat", _owner];
			[] remoteExec ["openCuratorInterface", _owner]; // Force open the curator interface if the reassignment succeeded
		} else {
			["Curator module failsafe failed. Could not re-establish curator module connection."] remoteExec ["systemChat", _owner];
		};
	};
};