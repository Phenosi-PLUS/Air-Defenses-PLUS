//Postinit
// Starts Air Defenses PLUS. Air defenses register themselves w/ inherited class eventhandlers, 
// same as EQplus autocloack, modded turret that inherits a base-game one; DONT need a compat

if (!PHEN_ADP_enabled) exitWith {};

private _parsed = parseSimpleArray PHEN_ADP_extraClasses;
if (_parsed isEqualType []) then {
    PHEN_ADP_extraClassList = _parsed select {_x isEqualType ""};
};

_cinematicList = (parseSimpleArray PHEN_ADP_cinematicTargets);
if (_cinematicList isEqualType []) then {
    _cinematicList = (_cinematicList select { (_x isEqualType "") });
    PHEN_ADP_cinematicVehicles = (_cinematicList select { (isClass (configFile >> "CfgVehicles" >> _x)) });
    PHEN_ADP_cinematicAmmo = (_cinematicList select { (isClass (configFile >> "CfgAmmo" >> _x)) });
};

_configClasses = (uiNamespace getVariable ["PHEN_ADP_configClasses", PHEN_ADP_BASE_CLASSES]);

{
    [_x, "initPost", {
        params ["_turret"];
        if (isServer) then {[_turret] call PHEN_ADP_fnc_registerTurret};
        [_turret] call PHEN_ADP_fnc_addActions;

        _canRespawn = (_turret getRespawnVehicleInfo 9);
        if (_canRespawn) then {
            _turret addEventHandler ["Respawn", { ["PHEN_ADP_respawned", _this] call CBA_fnc_serverEvent; }];
        };
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach (_configClasses + PHEN_ADP_extraClassList);

if (isServer) then {
    ["Air", "initPost", {
        params ["_plane"];
        [_plane] call PHEN_ADP_fnc_registerDrone;
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    ["PHEN_ADP_setState", PHEN_ADP_fnc_setState] call CBA_fnc_addEventHandler;
    ["PHEN_ADP_respawned", PHEN_ADP_fnc_onRespawn] call CBA_fnc_addEventHandler;
};

["PHEN_ADP_alarm", PHEN_ADP_fnc_playAlarm] call CBA_fnc_addEventHandler;
["PHEN_ADP_addActions", PHEN_ADP_fnc_addActions] call CBA_fnc_addEventHandler;
["PHEN_ADP_triggerAmmo", { triggerAmmo _this }] call CBA_fnc_addEventHandler;

if ((hasInterface) && { (isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) }) then {
    ["Air Defenses PLUS", (localize "STR_PHEN_ADP_Zeus_Module"), {
        params [["_position", [0, 0, 0], [[]]], ["_attached", objNull, [objNull]]];

        _onTurret = !(isNull _attached);
        if ((_onTurret) && { !(_attached getVariable ["PHEN_ADP_registered", false]) }) exitWith {
            ["STR_PHEN_ADP_Zeus_NotAirDefense"] call zen_common_fnc_showMessage;
        };

        _leaveAsIs = (localize "STR_PHEN_ADP_Zeus_LeaveAsIs");
        _typeTip = (localize "STR_PHEN_ADP_Eden_Threat_Desc");
        _shownTypes = (PHEN_ADP_THREAT_TYPES select { (call (_x select 3)) });
        _ignored = (_attached getVariable ["PHEN_ADP_ignore", []]);

        _rows = [
            ["COMBO", (localize "STR_PHEN_ADP_Action_AirDefense"), [[-1, 0, 1, 2, 3], ([_leaveAsIs] + PHEN_ADP_MODE_NAMES), 0]],
            ["COMBO", (localize "STR_PHEN_ADP_Action_Alarm"), [[-1, true, false], [_leaveAsIs, (localize "STR_PHEN_ADP_State_On"), (localize "STR_PHEN_ADP_State_Off")], 0]]
        ];
        _typeRow = { ["COMBO", [(localize (_x select 2)), _typeTip], [[-1, true, false], [_leaveAsIs, (localize "STR_PHEN_ADP_State_On"), (localize "STR_PHEN_ADP_State_Off")], 0]] };

        if (_onTurret) then {
            _rows = [
                ["COMBO", (localize "STR_PHEN_ADP_Action_AirDefense"), [[0, 1, 2, 3], PHEN_ADP_MODE_NAMES, (_attached getVariable ["PHEN_ADP_mode", 0])], true],
                ["CHECKBOX", (localize "STR_PHEN_ADP_AlarmEnabled"), [(_attached getVariable ["PHEN_ADP_alarm", true])], true]
            ];
            _typeRow = { ["CHECKBOX", [(localize (_x select 2)), _typeTip], [!((_x select 0) in _ignored)], true] };
        };

        _rows append (_shownTypes apply _typeRow);
        if (!_onTurret) then {
            _rows pushBack ["SLIDER:RADIUS", [(localize "STR_PHEN_ADP_Zeus_Radius"), (localize "STR_PHEN_ADP_Zeus_Radius_Desc")], [25, 10000, 500, 0, (ASLToAGL _position), [0.44, 0.74, 0.86, 0.7]]];
        };

        [(localize "STR_PHEN_ADP_Zeus_Module"), _rows, PHEN_ADP_fnc_zeusApply, {}, [_position, _attached, (_shownTypes apply { (_x select 0) })]] call zen_dialog_fnc_create;
    }, "\PHEN_ADP\data\ADP_logoSmall_256.paa"] call zen_custom_modules_fnc_register;
};

["PHEN_ADP_stateChanged", {
    params ["_turret"];
    if (!hasInterface) exitWith {};
    if (isNull _turret) exitWith {};

    private _ids = _turret getVariable ["PHEN_ADP_actionIds", []];
    if (_ids isEqualTo []) exitWith {};

    _turret setUserActionText [_ids select 0, [_turret, "mode"] call PHEN_ADP_fnc_statusText];
    _turret setUserActionText [_ids select 1, [_turret, "alarm"] call PHEN_ADP_fnc_statusText];
}] call CBA_fnc_addEventHandler;
