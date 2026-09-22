//Postinit
// Starts Air Defenses PLUS. Air defenses register themselves w/ inherited class eventhandlers, 
// same as EQplus autocloack, modded turret that inherits a base-game one; DONT need a compat

if (!PHEN_ADP_enabled) exitWith {};

private _parsed = parseSimpleArray PHEN_ADP_extraClasses;
if (_parsed isEqualType []) then {
    PHEN_ADP_extraClassList = _parsed select {_x isEqualType ""};
};

{
    [_x, "initPost", {
        params ["_turret"];
        if (isServer) then {[_turret] call PHEN_ADP_fnc_registerTurret};
        [_turret] call PHEN_ADP_fnc_addActions;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach (PHEN_ADP_BASE_CLASSES + PHEN_ADP_extraClassList);

if (isServer) then {
    ["Air", "initPost", {
        params ["_craft"];
        [_craft] call PHEN_ADP_fnc_registerDrone;
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    ["PHEN_ADP_setState", PHEN_ADP_fnc_setState] call CBA_fnc_addEventHandler;
};

["PHEN_ADP_alarm", PHEN_ADP_fnc_playAlarm] call CBA_fnc_addEventHandler;

["PHEN_ADP_stateChanged", {
    params ["_turret"];
    if (!hasInterface) exitWith {};
    if (isNull _turret) exitWith {};

    private _ids = _turret getVariable ["PHEN_ADP_actionIds", []];
    if (_ids isEqualTo []) exitWith {};

    _turret setUserActionText [_ids select 0, [_turret, "mode"] call PHEN_ADP_fnc_statusText];
    _turret setUserActionText [_ids select 1, [_turret, "alarm"] call PHEN_ADP_fnc_statusText];
}] call CBA_fnc_addEventHandler;
