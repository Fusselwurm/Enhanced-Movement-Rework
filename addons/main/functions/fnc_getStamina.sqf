#include "script_component.hpp"
/*
	Author: Diwako

	Description:
	Gets a unit's stamina (ACE compatible)

	Parameters:
	0: Unit <OBJECT>

	Returns:
	Stamina <SCALAR>
*/

params [["_unit",objNull,[objNull]]];

private _stamina = 100;

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	_stamina = ace_advanced_fatigue_anReserve / 23;
} else {
	_stamina = getStamina _unit;
};

_stamina
