#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Will make a unit climb or drop if possible.

	Parameters:
	0: Unit to perform action <OBJECT>

	Returns:
	Control override <BOOL>
*/

params [["_unit",objNull,[objNull]]];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (UNIVERSAL_EXIT_CONDITION) exitWith {false};

private _animPosASL = getPosASLVisual _unit;
private _targetPosASL = +_animPosASL;
private _dir = vectorDirVisual _unit;
private _duty = 0;
private _actionAnim = "";

// Climb/drop detection
_unit call FUNC(canClimb) params ["_canClimb","_climbOn","_height","_targetHeight","_climbAnimPosASL","_assistant"];
_unit call FUNC(canDrop) params ["_canDrop","_depth","_tooHigh"];

if (GVAR(climbingEnabled)) then {
	if (_canClimb) then {
		if (_climbOn) then {
			CLIMB_ON_PROCEDURE;
		} else {
			CLIMB_OVER_PROCEDURE;
		};
	};

	if (!_canClimb && _canDrop) then {
		DROP_PROCEDURE;
	};	
};

// Stop if can't climb or drop (+ Prevent high edge vault)
if (_actionAnim == "") exitWith {
	if (_tooHigh) then {
		if (IS_PLAYER(_unit)) then {LLSTRING(CantDropTooHigh) call FUNC(hint)};
		GVAR(preventHighVaulting)
	} else {
		false
	}
};

// Stop if out of stamina
private _stamina = _unit call FUNC(getStamina);

if (_stamina < (_duty * GVAR(staminaCoefficient))) exitWith {
	if (IS_PLAYER(_unit)) then {LLSTRING(CantClimbStamina) call FUNC(hint)};
	false
};

[_unit,_animPosASL,_targetPosASL,_actionAnim,_canClimb,_duty,_stamina,_assistant] call FUNC(startClimbing);

true
