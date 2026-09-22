PHEN_ADP_debugThreats = [];
PHEN_ADP_debugProjectileEH = -1;
PHEN_ADP_debugDrawEH = -1;
PHEN_ADP_fnc_debugOnProjectile = {
    params [["_projectile", objNull, [objNull]]];

    if (isNull _projectile) exitWith {};

    private _cat = (typeOf _projectile) call PHEN_ADP_fnc_classifyAmmo;
    if (_cat isEqualTo PHEN_ADP_CAT_IGNORE) exitWith {};

    private _isArcing = _cat isEqualTo PHEN_ADP_CAT_MISSILE || {_projectile call PHEN_ADP_fnc_isArcing};
    if (!_isArcing) exitWith {};

    private _parents = getShotParents _projectile;
    private _instigator = _parents select 1;
    if (isNull _instigator) then {_instigator = _parents select 0};

    private _hostile = true;
    if (!isNull _instigator) then {
        _hostile = [side _instigator, playerSide] call BIS_fnc_sideIsEnemy;
    };

    PHEN_ADP_debugThreats pushBack [_projectile, _hostile];
};

PHEN_ADP_fnc_debugDraw = {
    PHEN_ADP_debugThreats = PHEN_ADP_debugThreats select {!isNull (_x select 0)};

    {
        _x params ["_projectile", "_hostile"];

        private _colour = PHEN_ADP_DEBUG_COLOR_FRIENDLY;
        private _label = "FRIENDLY";
        if (_hostile) then {
            _colour = PHEN_ADP_DEBUG_COLOR;
            _label = "INCOMING";
        };

        drawIcon3D [
            PHEN_ADP_DEBUG_ICON,
            _colour,
            ASLToAGL (getPosASL _projectile),
            1,
            1,
            0,
            _label,
            1,
            0.03,
            "PuristaMedium"
        ];
    } forEach PHEN_ADP_debugThreats;
};

PHEN_ADP_fnc_debugStart = {
    if (!hasInterface) exitWith {};
    if (PHEN_ADP_debugDrawEH isNotEqualTo -1) exitWith {};

    PHEN_ADP_debugThreats = [];
    PHEN_ADP_debugProjectileEH = addMissionEventHandler ["ProjectileCreated", {_this call PHEN_ADP_fnc_debugOnProjectile}];
    PHEN_ADP_debugDrawEH = addMissionEventHandler ["Draw3D", {call PHEN_ADP_fnc_debugDraw}];
};
PHEN_ADP_fnc_debugStop = {
    if (PHEN_ADP_debugProjectileEH isNotEqualTo -1) then {
        removeMissionEventHandler ["ProjectileCreated", PHEN_ADP_debugProjectileEH];
        PHEN_ADP_debugProjectileEH = -1;
    };
    if (PHEN_ADP_debugDrawEH isNotEqualTo -1) then {
        removeMissionEventHandler ["Draw3D", PHEN_ADP_debugDrawEH];
        PHEN_ADP_debugDrawEH = -1;
    }; PHEN_ADP_debugThreats = [];
};

if (PHEN_ADP_debug) then {call PHEN_ADP_fnc_debugStart};
