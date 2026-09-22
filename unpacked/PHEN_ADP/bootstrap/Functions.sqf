//functions

PHEN_ADP_fnc_resolveIcon = {
    params [["_icon", "", [""]]];

    private _isProcedural = (_icon select [0,1]) isEqualTo "#";
    private _isShorthand = _icon isNotEqualTo "" && {!_isProcedural} && {!("\" in _icon)};
    if (_isShorthand) then {
        _icon = getText (configFile >> "CfgVehicleIcons" >> _icon);
        _isProcedural = (_icon select [0,1]) isEqualTo "#";
    };

    if (_icon isEqualTo "" || {_isProcedural}) exitWith {PHEN_ADP_ICON};

    _icon
}; // map icon for classname, falls back to PHEN_ADP_ICON when config fails


// air defense classname checker
PHEN_ADP_fnc_getConfigSetup = {
    params [["_type", "", [""]]];

    private _cached = PHEN_ADP_configSetupCache get _type;
    if (!isNil "_cached") exitWith {_cached};

    private _cfg = configFile >> "CfgVehicles" >> _type;
    private _turret = _cfg >> "Turrets" >> "MainTurret";

    private _weapon = "";
    private _magazine = "";
    if (isClass _turret) then {
        private _weapons = getArray (_turret >> "weapons");
        private _magazines = getArray (_turret >> "magazines");
        if (count _weapons > 0) then {_weapon = _weapons select 0};
        if (count _magazines > 0) then {_magazine = _magazines select 0};
    };

    private _ammo = "";
    if (_magazine isNotEqualTo "") then {
        _ammo = getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");
    };

    private _muzzleSpeed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
    if (_muzzleSpeed <= 0) then {_muzzleSpeed = 900};

    private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
    private _maxRange = getNumber (_weaponCfg >> "maxRange");
    private _minRange = getNumber (_weaponCfg >> "minRange");

    private _isMissile = false;
    if (_ammo isNotEqualTo "") then {
        _isMissile = _ammo isKindOf ["MissileCore", configFile >> "CfgAmmo"];
    };

    private _derivedRange = 2800;
    if (_isMissile) then {_derivedRange = (_maxRange * 0.85) max 1500};

    private _mode = "gun";
    if (_isMissile) then {_mode = "missile"};

    private _icon = getText (_cfg >> "icon");

    private _configSetup = createHashMapFromArray [
        ["enabled", true],
        ["mode", _mode],
        ["range", _derivedRange],
        ["needsAiming", _minRange >= 500],
        ["shotDelay", 2],
        ["fuzeRadius", 12],
        ["muzzleSpeed", _muzzleSpeed],
        ["weapon", _weapon],
        ["ammo", _ammo],
        ["icon", _icon]
    ];

    private _block = _cfg >> "PHEN_ADP";
    if (isClass _block) then {
        if (isNumber (_block >> "enabled")) then {_configSetup set ["enabled", (getNumber (_block >> "enabled")) > 0]};
        if (isText (_block >> "mode")) then {_configSetup set ["mode", getText (_block >> "mode")]};
        if (isNumber (_block >> "range")) then {_configSetup set ["range", getNumber (_block >> "range")]};
        if (isNumber (_block >> "needsAiming")) then {_configSetup set ["needsAiming", (getNumber (_block >> "needsAiming")) > 0]};
        if (isNumber (_block >> "shotDelay")) then {_configSetup set ["shotDelay", getNumber (_block >> "shotDelay")]};
        if (isNumber (_block >> "fuzeRadius")) then {_configSetup set ["fuzeRadius", getNumber (_block >> "fuzeRadius")]};
        if (isText (_block >> "icon")) then {_configSetup set ["icon", getText (_block >> "icon")]};
    } else {
        private _extra = PHEN_ADP_extraClassList findIf {_type isKindOf _x};
        if (_extra isEqualTo -1) then {_configSetup set ["enabled", false]};
    };

    _configSetup set ["icon", (_configSetup get "icon") call PHEN_ADP_fnc_resolveIcon];

    PHEN_ADP_configSetupCache set [_type, _configSetup];
    _configSetup
};

//threat categories, number is what PHEN_ADP_fnc_classifyAmmo caches per ammoclassname
PHEN_ADP_CAT_IGNORE = 0;
PHEN_ADP_CAT_BALLISTIC = 1;  // ShellCore, artillery and mortar
PHEN_ADP_CAT_SUB = 2;     // SubmunitionCore, MLRS bomblets
PHEN_ADP_CAT_MISSILE = 3;   // MissileCore, cruise and AT
PHEN_ADP_CAT_ROCKET = 4;  // RocketCore, rocket artillery and RPGs
PHEN_ADP_CAT_DRONE = 5;      // not ammo, comes in through the Air class eventhandler

// sorts an ammo classname into a PHEN_ADP_CAT_ category and caches it
// ONLY once per classname per session
PHEN_ADP_fnc_classifyAmmo = {
    params [["_ammo", "", [""]]];

    private _cached = PHEN_ADP_ammoCache get _ammo;
    if (!isNil "_cached") exitWith {_cached};

    private _root = configFile >> "CfgAmmo";
    private _cat = PHEN_ADP_CAT_IGNORE;

    private _blacklisted = PHEN_ADP_AMMO_BLACKLIST findIf {_ammo isKindOf [_x, _root]};
    if (_blacklisted isEqualTo -1) then {
        switch (true) do {
            case (_ammo isKindOf ["MissileCore", _root]): {_cat = PHEN_ADP_CAT_MISSILE};
            case (_ammo isKindOf ["SubmunitionCore", _root]): {_cat = PHEN_ADP_CAT_SUB};
            case (_ammo isKindOf ["ShellCore", _root]): {_cat = PHEN_ADP_CAT_BALLISTIC};
            case (_ammo isKindOf ["RocketCore", _root]): {_cat = PHEN_ADP_CAT_ROCKET};
            default {};
        };
    };

    PHEN_ADP_ammoCache set [_ammo, _cat];
    _cat
};

// tank rounds and RPGs share the same base classes as artillery, the ARc is the only difference
// artilleryLock gets it for every base-game shell, submunition and artillery rocket, and it is inherited so it just works for mods that build off those
PHEN_ADP_fnc_isArcing = {
    params [["_projectile", objNull, [objNull]]];

    if (isNull _projectile) exitWith {false};

    private _ammo = typeOf _projectile;
    private _lock = PHEN_ADP_arcCache get _ammo;
    if (isNil "_lock") then {
        _lock = (getNumber (configFile >> "CfgAmmo" >> _ammo >> "artilleryLock")) > 0;
        PHEN_ADP_arcCache set [_ammo, _lock];
    };
    if (_lock) exitWith {true};

    //ANGLE and not climb rate, a sabot at 1550m/s only needs a fifth of a degree to climb 5m/s
    //15 degrees, a tank round needs about 2 and a mortar never goes under 45
    private _velocity = velocity _projectile;
    private _speed = vectorMagnitude _velocity;
    _speed > 1 && {(asin ((_velocity select 2) / _speed)) >= 15}
};

// server ON/OFF switch registering
PHEN_ADP_fnc_registerTurret = {
    params [["_turret", objNull, [objNull]]];

    if (!isServer) exitWith {};
    if (isNull _turret) exitWith {};
    if (!PHEN_ADP_enabled) exitWith {};
    if (_turret getVariable ["PHEN_ADP_registered", false]) exitWith {};

    private _configSetup = (typeOf _turret) call PHEN_ADP_fnc_getConfigSetup;
    if !(_configSetup getOrDefault ["enabled", false]) exitWith {};

    private _startMode = PHEN_ADP_defaultModeGun;
    if ((_configSetup getOrDefault ["mode", "gun"]) isEqualTo "missile") then {_startMode = PHEN_ADP_defaultModeMissile};

    _turret setVariable ["PHEN_ADP_registered", true, true];
    _turret setVariable ["PHEN_ADP_mode", _startMode, true];
    _turret setVariable ["PHEN_ADP_alarm", true, true];
    _turret setVariable ["PHEN_ADP_configSetup", _configSetup];
    _turret setVariable ["PHEN_ADP_busyUntil", 0];

    _turret setVehicleReportRemoteTargets true;
    _turret setVehicleReportOwnPosition true;

    PHEN_ADP_batteries pushBackUnique _turret;

    _turret addEventHandler ["Killed", {(_this select 0) call PHEN_ADP_fnc_unregisterTurret}];
    _turret addEventHandler ["Deleted", {(_this select 0) call PHEN_ADP_fnc_unregisterTurret}];

    if ((_configSetup getOrDefault ["mode", "gun"]) isEqualTo "missile") then {
        //hand the round that just fired its target
        _turret addEventHandler ["Fired", {
            params ["_turret", "", "", "", "", "", "_projectile"];

            private _target = _turret getVariable ["PHEN_ADP_currentTarget", objNull];
            if (isNull _target) exitWith {};

            _turret setVariable ["PHEN_ADP_currentTarget", objNull];
            [_projectile, _target, _turret getVariable ["PHEN_ADP_configSetup", createHashMap], _turret] call PHEN_ADP_fnc_guideMissile;
        }];
    } else {
        _turret addEventHandler ["Fired", {
            params ["_turret"];

            private _target = _turret getVariable ["PHEN_ADP_engageTarget", objNull];
            if (isNull _target) exitWith {};

            //cap/exit guard so it doesnt spam call on a 40 round burst
            private _now = CBA_missionTime;
            if (_now < (_turret getVariable ["PHEN_ADP_engageShotAt", 0])) exitWith {};

            private _speed = _turret getVariable ["PHEN_ADP_engageSpeed", 900];
            private _flightTime = ((_target distance _turret) / (_speed max 1)) + 0.6;
            _turret setVariable ["PHEN_ADP_engageShotAt", _now + _flightTime + 0.5];
            [PHEN_ADP_fnc_intercept, [_target, objNull], _flightTime] call CBA_fnc_waitAndExecute;
        }];
    };

    if (PHEN_ADP_projectileEH isEqualTo -1) then {
        PHEN_ADP_projectileEH = addMissionEventHandler ["ProjectileCreated", {_this call PHEN_ADP_fnc_onProjectile}];
    };
};

// OPPOSITE of above fnc
PHEN_ADP_fnc_unregisterTurret = {
    params [["_turret", objNull, [objNull]]];

    if (!isServer) exitWith {};

    private _index = PHEN_ADP_batteries find _turret;
    if (_index isNotEqualTo -1) then {PHEN_ADP_batteries deleteAt _index};
    PHEN_ADP_batteries = PHEN_ADP_batteries select {!isNull _x};

    if (!isNull _turret) then {
        _turret setVariable ["PHEN_ADP_registered", false, true];
        private _proxy = _turret getVariable ["PHEN_ADP_proxy", objNull];
        if (!isNull _proxy) then {
            detach _proxy;
            deleteVehicleCrew _proxy;
            deleteVehicle _proxy;
        };
        _turret setVariable ["PHEN_ADP_proxy", objNull];
    };

    if (PHEN_ADP_batteries isNotEqualTo []) exitWith {};

    if (PHEN_ADP_projectileEH isNotEqualTo -1) then {
        removeMissionEventHandler ["ProjectileCreated", PHEN_ADP_projectileEH];
        PHEN_ADP_projectileEH = -1;
    };
    call PHEN_ADP_fnc_stopTracker;
};

//Handle drones
PHEN_ADP_fnc_registerDrone = {
    params [["_craft", objNull, [objNull]]];

    if (!isServer) exitWith {};
    if (!PHEN_ADP_trackDrones) exitWith {};
    if (isNull _craft) exitWith {};
    if !(unitIsUAV _craft) exitWith {};
    if (_craft getVariable ["PHEN_ADP_isProxy", false]) exitWith {};

    _craft addEventHandler ["Engine", {
        params ["_craft", "_running"];
        if (!_running) exitWith {};
        if (!PHEN_ADP_trackDrones) exitWith {};
        _craft setVariable ["PHEN_ADP_droneWait", CBA_missionTime + 90];
        [_craft, PHEN_ADP_CAT_DRONE, side _craft] call PHEN_ADP_fnc_addThreat;
    }];
};

// gate/condi check for ProjectileCreated
PHEN_ADP_fnc_onProjectile = {
    params [["_projectile", objNull, [objNull]]];

    if (PHEN_ADP_batteries isEqualTo []) exitWith {
        if (PHEN_ADP_projectileEH isNotEqualTo -1) then {
            removeMissionEventHandler ["ProjectileCreated", PHEN_ADP_projectileEH];
            PHEN_ADP_projectileEH = -1;
        };
    };

    if (isNull _projectile) exitWith {};

    private _parents = getShotParents _projectile;
    if ((_parents select 0) in PHEN_ADP_batteries) exitWith {}; //friendly turret check

    private _cat = (typeOf _projectile) call PHEN_ADP_fnc_classifyAmmo;
    if (_cat isEqualTo PHEN_ADP_CAT_IGNORE) exitWith {};

    private _wanted = switch (_cat) do {
        case PHEN_ADP_CAT_MISSILE: {PHEN_ADP_trackMissile};
        case PHEN_ADP_CAT_SUB: {PHEN_ADP_trackSubmunition};
        case PHEN_ADP_CAT_BALLISTIC: {PHEN_ADP_trackBallistic};
        case PHEN_ADP_CAT_ROCKET: {PHEN_ADP_trackRocket};
        default {false};
    };
    if (!_wanted) exitWith {};

    private _isArcing = _cat isEqualTo PHEN_ADP_CAT_MISSILE || {_projectile call PHEN_ADP_fnc_isArcing};
    if (!_isArcing) exitWith {}; //a missile moves itself around, so where it is pointed at launch means nothing

    private _side = sideUnknown;
    if (!PHEN_ADP_friendlyFire) then {
        private _instigator = _parents select 1;
        if (isNull _instigator) then {_instigator = _parents select 0};
        if (!isNull _instigator) then {_side = side _instigator};
    };

    [_projectile, _cat, _side] call PHEN_ADP_fnc_addThreat;
};

// adds incoming proj to tracking list and start tracker
PHEN_ADP_fnc_addThreat = {
    params [["_threat", objNull, [objNull]], ["_cat", PHEN_ADP_CAT_MISSILE, [0]], ["_side", sideUnknown, [sideUnknown]]];

    if (!isServer) exitWith {};
    if (isNull _threat) exitWith {};
    if (_threat in PHEN_ADP_threats) exitWith {};
    if (count PHEN_ADP_threats >= 120) exitWith {}; //HARD CAP, I doubt anyone would go over 120 at once in their mission tho..?

    private _inReach = PHEN_ADP_batteries findIf {
        private _configSetup = _x getVariable ["PHEN_ADP_configSetup", createHashMap];
        private _range = (_configSetup getOrDefault ["range", 0]) * PHEN_ADP_rangeMultiplier;
        (_x distance2D _threat) < (_range + 3000)
    };
    if (_inReach isEqualTo -1) exitWith {};

    _threat setVariable ["PHEN_ADP_cat", _cat];
    _threat setVariable ["PHEN_ADP_side", _side];
    PHEN_ADP_threats pushBack _threat;

    call PHEN_ADP_fnc_startTracker;
};

PHEN_ADP_fnc_startTracker = {
    if (!isServer) exitWith {};
    if (PHEN_ADP_trackerHandle isNotEqualTo -1) exitWith {};

    PHEN_ADP_trackerHandle = [PHEN_ADP_fnc_trackerTick, 0.1, []] call CBA_fnc_addPerFrameHandler;
};

// OPPOSITE of above, also cleans threat list
PHEN_ADP_fnc_stopTracker = {
    if (!isServer) exitWith {};
    if (PHEN_ADP_trackerHandle isEqualTo -1) exitWith {};

    PHEN_ADP_trackerHandle call CBA_fnc_removePerFrameHandler;
    PHEN_ADP_trackerHandle = -1;
    PHEN_ADP_threats = [];

    //tick is what takes proxies back, so it cannot stop with one still attached to a shell
    {[_x] call PHEN_ADP_fnc_endEngage} forEach PHEN_ADP_batteries;
};

//shell is gone or out of reach, clear the state and cleanup the proxy
PHEN_ADP_fnc_endEngage = {
    params [["_turret", objNull, [objNull]], ["_pause", true, [true]], ["_engageId", -1, [0]]];

    if (isNull _turret) exitWith {};
    if !(_turret getVariable ["PHEN_ADP_engaging", false]) exitWith {};

    //`_engageId` only lets a callback end the shot it belongs to; using -1 skips we skip that check
    private _current = _turret getVariable ["PHEN_ADP_engageId", 0];
    if (_engageId isNotEqualTo -1 && {_engageId isNotEqualTo _current}) exitWith {};

    _turret setVariable ["PHEN_ADP_engaging", false];
    _turret setVariable ["PHEN_ADP_engageTarget", objNull];

    //`_pause` false leaves the proxy crewed and out there aka when target swapping
    if (!_pause) exitWith {};

    [_turret, _turret getVariable ["PHEN_ADP_proxy", objNull]] call PHEN_ADP_fnc_pauseProxy;
};

//target picker, objnull when not
PHEN_ADP_fnc_pickForTurret = {
    params [["_turret", objNull, [objNull]], ["_range", 0, [0]]];

    private _mode = _turret getVariable ["PHEN_ADP_mode", 0];
    if (_mode isEqualTo 0) exitWith {objNull};
    if !(someAmmo _turret) exitWith {objNull};

    private _crewed = PHEN_ADP_pauseWhenCrewed && {((crew _turret) findIf {isPlayer _x}) isNotEqualTo -1};
    if (_crewed) exitWith {objNull};

    private _now = CBA_missionTime;
    private _turretSide = side _turret;

    private _candidates = PHEN_ADP_threats select {
        (_x distance _turret) <= _range
        && {(_x getVariable ["PHEN_ADP_lockedUntil", 0]) <= _now}
        && {
            PHEN_ADP_friendlyFire
            || {
                private _threatSide = _x getVariable ["PHEN_ADP_side", sideUnknown];
                _threatSide isEqualTo sideUnknown
                || {[_threatSide, _turretSide] call BIS_fnc_sideIsEnemy}
            }
        }
    };
    if (_candidates isEqualTo []) exitWith {objNull};

    private _target = [_candidates, _turret, _mode] call PHEN_ADP_fnc_pickTarget;
    if (isNull _target) exitWith {objNull};

    //quick lock, the engagement loop keeps tracking it as long as the turret holds it
    _target setVariable ["PHEN_ADP_lockedUntil", _now + 5];
    _target
};

//only perframe handler this mod runs
PHEN_ADP_fnc_trackerTick = {
    PHEN_ADP_threats = PHEN_ADP_threats select {
        !isNull _x
        && {alive _x}
        && {
            private _cat = _x getVariable ["PHEN_ADP_cat", PHEN_ADP_CAT_MISSILE];
            //case for landed drones; basically just waiting bit
            if (_cat isEqualTo PHEN_ADP_CAT_DRONE) then {
                private _airborne = !(isTouchingGround _x) && {((getPosATL _x) select 2) > 20};
                _airborne || {CBA_missionTime < (_x getVariable ["PHEN_ADP_droneWait", 0])}
            } else {true}
        }
    }; //no exitWithhere, #select returns the exitWith value instead of array

    PHEN_ADP_batteries = PHEN_ADP_batteries select {!isNull _x && {alive _x}};

    if (PHEN_ADP_threats isEqualTo [] || {PHEN_ADP_batteries isEqualTo []}) exitWith {
        call PHEN_ADP_fnc_stopTracker;
    };

    private _now = CBA_missionTime;

    {
        private _turret = _x;
        if !(local _turret) then {continue};

        private _configSetup = _turret getVariable ["PHEN_ADP_configSetup", createHashMap];
        private _range = (_configSetup getOrDefault ["range", 0]) * PHEN_ADP_rangeMultiplier;
        private _isMissile = (_configSetup getOrDefault ["mode", "gun"]) isEqualTo "missile";

        //has to go ABOVE the busy check, a turret mid engagement is busy
        if (_turret getVariable ["PHEN_ADP_engaging", false]) then {
            private _engaged = _turret getVariable ["PHEN_ADP_engageTarget", objNull];
            private _lost = isNull _engaged
                || {!alive _engaged}
                || {(PHEN_ADP_threats find _engaged) isEqualTo -1}
                || {(_engaged distance _turret) > _range};

            if (!_lost) then {
                //ensure two turrets dont waste on a single target
                _engaged setVariable ["PHEN_ADP_lockedUntil", _now + 5];

                if (_now > (_turret getVariable ["PHEN_ADP_orderAt", 0])) then {
                    _turret setVariable ["PHEN_ADP_orderAt", _now + 1];
                    private _proxy = _turret getVariable ["PHEN_ADP_proxy", objNull];
                    [_turret, _proxy] call PHEN_ADP_fnc_shareProxy;
                    if (!_isMissile) then {[_turret, _proxy] call PHEN_ADP_fnc_setTargetbehaviour};
                };
            } else {
                //target swap; no cleanup or anything yet just a new target
                [_turret, false] call PHEN_ADP_fnc_endEngage;

                private _next = [_turret, _range] call PHEN_ADP_fnc_pickForTurret;
                if (isNull _next) then {
                    [_turret, _turret getVariable ["PHEN_ADP_proxy", objNull]] call PHEN_ADP_fnc_pauseProxy;
                } else {
                    [_turret, _next, _configSetup] call PHEN_ADP_fnc_engage;
                };
            };
      }; //runs until the shell is dead, off the list or out of reach

        //`endEngage` clears the flag, and a target swap sets it straight back
        if (_turret getVariable ["PHEN_ADP_engaging", false]) then { continue };

        private _busyUntil = _turret getVariable ["PHEN_ADP_busyUntil", 0];
        if (_now < _busyUntil) then { continue };

        private _target = [_turret, _range] call PHEN_ADP_fnc_pickForTurret;
        if (isNull _target) then { continue };

        _turret setVariable ["PHEN_ADP_busyUntil", _now + (_configSetup getOrDefault ["shotDelay", 2])];
        [_turret, _target, _configSetup] call PHEN_ADP_fnc_engage;
    } forEach PHEN_ADP_batteries;
};

//filter candidates, mode 1 random, 2 closest, 3 earliest ANd nearest
PHEN_ADP_fnc_pickTarget = {
    params [["_candidates", [], [[]]], ["_turret", objNull, [objNull]], ["_mode", 3, [0]]];

    if (_candidates isEqualTo []) exitWith { objNull };
    if (_mode isEqualTo 1) exitWith { selectRandom _candidates };

    if (_mode isEqualTo 2) exitWith {
        private _best = objNull;
        private _bestDistance = 1e10;
        {
            private _distance = _x distance _turret;
            if (_distance < _bestDistance) then {
                _best = _x;
                _bestDistance = _distance;
            };
        } forEach _candidates;
        _best
    };

    private _best = objNull;
    private _bestScore = 1e10;
    private _turretPos = getPosASL _turret;

    {
        private _pos = getPosASL _x;
        private _velocity = velocity _x;
        private _climb = -(_velocity select 2);
        private _altitude = (_pos select 2) - (_turretPos select 2);
        private _root = (_climb ^ 2) + (2 * 9.81 * _altitude);

        if (_root >= 0) then {
            private _impactTime = (_climb + sqrt _root) / 9.81;
            private _impactPos = [
                (_pos select 0) + ((_velocity select 0) * _impactTime),
                (_pos select 1) + ((_velocity select 1) * _impactTime)
            ];
            //eight meters miss distance is ~about a second of warning
            private _score = (_turretPos distance2D _impactPos) + (_impactTime * 8);

            private _cat = _x getVariable ["PHEN_ADP_cat", PHEN_ADP_CAT_BALLISTIC];
            if (_cat isEqualTo PHEN_ADP_CAT_MISSILE) then {_score = _score * 0.5};
            if (_cat isEqualTo PHEN_ADP_CAT_DRONE) then {_score = _score * 1.5};

            if (_score < _bestScore) then {
                _best = _x;
                _bestScore = _score;
            };
        };
    } forEach _candidates;

    if (isNull _best) then {_best = selectRandom _candidates};
    _best
};

PHEN_ADP_fnc_engage = {
    params [["_turret", objNull, [objNull]], ["_target", objNull, [objNull]], ["_configSetup", createHashMap, [createHashMap]]];

    if (isNull _turret || {isNull _target}) exitWith {};

    _turret setVehicleRadar 1; //resets in pauseproxy

    [_turret] call PHEN_ADP_fnc_alarm;

    _turret setVariable ["PHEN_ADP_engaging", true];
    _turret setVariable ["PHEN_ADP_engageTarget", _target];

    _turret setVariable ["PHEN_ADP_engageId", (_turret getVariable ["PHEN_ADP_engageId", 0]) + 1];

    if ((_configSetup getOrDefault ["mode", "gun"]) isEqualTo "missile") exitWith {
        [_turret, _target, _configSetup] call PHEN_ADP_fnc_engageMissile;
    };

    [_turret, _target, _configSetup] call PHEN_ADP_fnc_engageGun;
};

// attach the proxy to the shell, set behaviour
//no scripted aiming, and no forced firing; basegame does all the rest
PHEN_ADP_fnc_engageGun = {
    params [["_turret", objNull, [objNull]], ["_target", objNull, [objNull]], ["_configSetup", createHashMap, [createHashMap]]];

    private _proxy = _turret call PHEN_ADP_fnc_getProxy;
    if (isNull _proxy) exitWith {[_turret] call PHEN_ADP_fnc_endEngage};

    _proxy call PHEN_ADP_fnc_crewProxy;

    _turret setVariable ["PHEN_ADP_engageSpeed", _configSetup getOrDefault ["muzzleSpeed", 900]];
    _turret setVariable ["PHEN_ADP_engageShotAt", 0];
    _turret setVariable ["PHEN_ADP_orderAt", CBA_missionTime + 1];

    detach _proxy;
    _proxy attachTo [_target, [0, 5, 0]];
    [_turret, _proxy] call PHEN_ADP_fnc_shareProxy;

    //a gunner in a group set to safe or yellow will not shoot at anything, so we fix that
    private _gunner = gunner _turret;
    if (!isNull _gunner) then {
        _gunner enableAI "TARGET";
        _gunner enableAI "AUTOTARGET";
        (group _gunner) setCombatMode "RED";
    };

    [_turret, _proxy] call PHEN_ADP_fnc_setTargetbehaviour;
};

PHEN_ADP_fnc_setTargetbehaviour = {
    params [["_turret", objNull, [objNull]], ["_proxy", objNull, [objNull]]];

    if (isNull _turret || {isNull _proxy}) exitWith {};

    _turret reveal [_proxy, 4];
    _turret doWatch _proxy;
    _turret doTarget _proxy;
    _turret doFire _proxy;
};

PHEN_ADP_fnc_engageMissile = {
    params [["_turret", objNull, [objNull]], ["_target", objNull, [objNull]], ["_configSetup", createHashMap, [createHashMap]]];

    private _proxy = _turret call PHEN_ADP_fnc_getProxy;
    if (!isNull _proxy) then {
        _proxy call PHEN_ADP_fnc_crewProxy;
        detach _proxy;
        _proxy attachTo [_target, [0, 5, 0]];
        [_turret, _proxy] call PHEN_ADP_fnc_shareProxy;
    };

    private _aimPos = getPosASL _target;
    _aimPos set [2, (_aimPos select 2) + (((_turret distance2D _target) * tan 22) max 400)];
    _turret doTarget objNull;
    _turret doWatch (ASLToAGL _aimPos);

    if !(_configSetup getOrDefault ["needsAiming", true]) exitWith {
        [_turret, _target] call PHEN_ADP_fnc_fireInterceptor;
    };

    [{
        params ["_turret", "_target", "_aimPos", "_deadline"];
        if (CBA_missionTime > _deadline) exitWith {true};
        if (isNull _turret || {isNull _target} || {!alive _target}) exitWith {true};

        //wait for turret gun allignment
        private _direction = _turret weaponDirection (currentWeapon _turret);
        private _wanted = (getPosASL _turret) vectorFromTo _aimPos;
        (_direction vectorCos _wanted) > 0.95
    }, {
        params ["_turret", "_target", "_aimPos"];
        if (isNull _turret) exitWith {};

        //tick may/can have handed this launcher a different shell while it was still turning
        if (_target isNotEqualTo (_turret getVariable ["PHEN_ADP_engageTarget", objNull])) exitWith {};

        //gotta check it again here
        private _direction = _turret weaponDirection (currentWeapon _turret);
        private _wanted = (getPosASL _turret) vectorFromTo _aimPos;
        private _aligned = (_direction vectorCos _wanted) > 0.95;
        private _elevation = _direction select 2;

        _turret doWatch objNull;
        if (!_aligned) exitWith {[_turret] call PHEN_ADP_fnc_endEngage};
        if (_elevation < 0.1) exitWith {[_turret] call PHEN_ADP_fnc_endEngage};

        [_turret, _target] call PHEN_ADP_fnc_fireInterceptor;
    }, [_turret, _target, _aimPos, CBA_missionTime + 5]] call CBA_fnc_waitUntilAndExecute;
};

// save target on turret and fire (doWatch STAYS ON, and gets reset after)
PHEN_ADP_fnc_fireInterceptor = {
    params [["_turret", objNull, [objNull]], ["_target", objNull, [objNull]]];

    if (isNull _turret) exitWith {};

    private _canFire = !isNull _target && {alive _target} && {local _turret} && {someAmmo _turret};
    if (!_canFire) exitWith {[_turret] call PHEN_ADP_fnc_endEngage};

    _turret setVariable ["PHEN_ADP_currentTarget", _target];

    private _proxy = _turret getVariable ["PHEN_ADP_proxy", objNull];
    if (!isNull _proxy) then {
        _turret reveal [_proxy, 4];
        _turret doTarget _proxy;
    };

    //ACE grabs any AI fired round onto its own IR seeker, which cannot see an invisible proxy, so it needs this down for the shot
    private _aceWas = missionNamespace getVariable ["ace_missileguidance_enabled", -1];
    if (_aceWas > 1) then {
        ace_missileguidance_enabled = 1;
        [{ace_missileguidance_enabled = _this}, _aceWas, 0.5] call CBA_fnc_waitAndExecute;
    };

    //the AI will not fire this itself so force it
    //[0] is the main turret like 99% of the time so this is fineeeee
    [_turret, currentWeapon _turret, [0]] call BIS_fnc_fire;

    private _engageId = _turret getVariable ["PHEN_ADP_engageId", 0];
    [{
        params ["_turret", "_engageId"];
        if (isNull _turret) exitWith {};
        if (_engageId isNotEqualTo (_turret getVariable ["PHEN_ADP_engageId", 0])) exitWith {};
        _turret doWatch objNull;
    }, [_turret, _engageId], 4] call CBA_fnc_waitAndExecute;
};

// _object: object to add/remove
// _action: 0 = remove, 1 = add
// _persistent: true = keep synced until object is destroyed, false = run once
PHEN_ADP_ZeusEditableObject = {
    params [
        ["_object", objNull, [objNull]],
        ["_action", 1, [0]],
        ["_persistent", false, [false]]
    ];

    if (isNull _object) exitWith {
        diag_log "[PHEN_ADP_ZeusEditableObject] ERROR: Null object passed.";
    };

    if !(_action in [0,1]) exitWith {
        diag_log format ["[PHEN_ADP_ZeusEditableObject] ERROR: Invalid action %1", _action];
    };

    private _apply = {
        params ["_object","_action"];
        {
            [_x, [[_object], (_action isEqualTo 1)]] remoteExecCall ["addCuratorEditableObjects", 0, _object];
        } forEach allCurators;
    };

    [_object, _action] call _apply;

    if (_persistent) then {
        [_object, _action, _apply] spawn {
            params ["_object","_action","_apply"];

            while {(!isNil "_object" && {alive _object} && {!(isNull _object)})} do {
                sleep 10;
                if (!isNil "_object" && {alive _object} && {!(isNull _object)}) then {
                    [_object, _action] call _apply;
                };
            };
        };
    };
};


// every proxy crew on a side shares ONE group
PHEN_ADP_fnc_getProxyGroup = {
    params [["_side", east, [east]]];

    private _key = str _side;
    private _group = PHEN_ADP_proxyGroups getOrDefault [_key, grpNull];
    if (!isNull _group) exitWith {_group};

    _group = createGroup [_side, true];
    PHEN_ADP_proxyGroups set [_key, _group];
    _group
};

// crew the proxy and put its crew in the shared group
PHEN_ADP_fnc_crewProxy = {
    params [["_proxy", objNull, [objNull]]];

    if (isNull _proxy) exitWith {};
    if ((crew _proxy) isNotEqualTo []) exitWith {};

    createVehicleCrew _proxy;

    private _units = crew _proxy;
    if (_units isEqualTo []) exitWith {};

    private _spawnedIn = group (_units select 0);
    private _shared = [side (_units select 0)] call PHEN_ADP_fnc_getProxyGroup;

    if (isNull _shared || {_spawnedIn isEqualTo _shared}) exitWith {};

    _units joinSilent _shared;
    if ((units _spawnedIn) isEqualTo []) then {deleteGroup _spawnedIn};
};

PHEN_ADP_fnc_shareProxy = {
    params [["_turret", objNull, [objNull]], ["_proxy", objNull, [objNull]]];

    if (isNull _turret || {isNull _proxy}) exitWith {};

    private _side = side _turret;
    _proxy confirmSensorTarget [_side, true];
    _side reportRemoteTarget [_proxy, 3];
};

// hidden target proxy creation part
//ai be aimting at this and not the projectile
PHEN_ADP_fnc_getProxy = {
    params [["_turret", objNull, [objNull]]];

    private _proxy = _turret getVariable ["PHEN_ADP_proxy", objNull];
    if (!isNull _proxy) exitWith {_proxy}; //ONLY one!

    private _turretSide = side _turret;
    private _pick = PHEN_ADP_PROXY_BY_SIDE findIf {[_x select 0, _turretSide] call BIS_fnc_sideIsEnemy};
    private _class = PHEN_ADP_PROXY_FALLBACK;
    if (_pick isNotEqualTo -1) then {_class = (PHEN_ADP_PROXY_BY_SIDE select _pick) select 1};

    _proxy = createVehicle [_class, [0, 0, 500], [], 0, "CAN_COLLIDE"];
    [_proxy, 2] remoteExec ["setFeatureType", 0];
    [_proxy, 2] remoteExec ["setFeatureType", 0];
    [{ params ["_proxy"];[_proxy, 0] remoteExecCall ["PHEN_ADP_ZeusEditableObject", 2, _proxy]; }, [_proxy], 1] call CBA_fnc_waitAndExecute;

    _proxy allowDamage false;
    _proxy attachTo [_turret, [0, 0, -12001]];
    _proxy setVariable ["PHEN_ADP_isProxy", true, true];
    _turret setVariable ["PHEN_ADP_proxy", _proxy];

    _proxy
};

// engagement done; give the gun back and save the proxy under the turret for the next one
PHEN_ADP_fnc_pauseProxy = {
    params [["_turret", objNull, [objNull]], ["_proxy", objNull, [objNull]]];

    if (!isNull _proxy) then {
        detach _proxy;
        deleteVehicleCrew _proxy;
        if (!isNull _turret) then {_proxy confirmSensorTarget [side _turret, false]};
    };

    private _keep = !isNull _turret && {alive _turret};
    if (_keep) then {
        _turret setVehicleRadar 0;

        private _configSetup = _turret getVariable ["PHEN_ADP_configSetup", createHashMap];
        _turret setVariable ["PHEN_ADP_busyUntil", CBA_missionTime + (_configSetup getOrDefault ["shotDelay", 2])];
        // {_x enableAI "AUTOTARGET"} forEach (crew _turret);

        if (!isNull _proxy) then {
            _turret doTarget objNull;
            _turret doWatch objNull;
            _proxy attachTo [_turret, [0, 0, -12001]];
        };
    } else {
        if (!isNull _proxy) then {deleteVehicle _proxy};
        if (!isNull _turret) then {_turret setVariable ["PHEN_ADP_proxy", objNull]};
    };
};

// setMissileTarget is the main way, unguided/or ACE missileguide overwrite wont work with base-game so use scripted as fallback
PHEN_ADP_fnc_guideMissile = {
    params [["_missile", objNull, [objNull]], ["_target", objNull, [objNull]], ["_configSetup", createHashMap, [createHashMap]], ["_turret", objNull, [objNull]]];

    private _engageId = _turret getVariable ["PHEN_ADP_engageId", 0];
    if (isNull _missile || {isNull _target}) exitWith {[_turret, true, _engageId] call PHEN_ADP_fnc_endEngage};

    private _ammoCfg = configFile >> "CfgAmmo" >> (typeOf _missile);

    //a round with no maneuvrability cannot fly/steer etc
    private _canTurn = (getNumber (_ammoCfg >> "maneuvrability")) > 0;

    //the proxy is attached to the artyshell
    private _proxy = _turret getVariable ["PHEN_ADP_proxy", objNull];
    private _engine = _canTurn && {!isNull _proxy};
    if (_engine) then {_missile setMissileTarget [_proxy, true]};

    private _top = getNumber (_ammoCfg >> "maxSpeed");
    if (_top <= 0) then {_top = 250};

    private _state = createHashMapFromArray [
        ["proxy", _proxy],
        ["engine", _engine],
        ["held", false],
        ["fails", 0],
        ["top", _top],
        ["closest", _missile distance _target],
        ["deadline", CBA_missionTime + 45],   //self destructs max time cap
        ["armed", CBA_missionTime + 3],
        ["fuze", _configSetup getOrDefault ["fuzeRadius", 12]],
        ["lastTick", CBA_missionTime],
        ["commanded", vectorMagnitude (velocity _missile)]
    ];

    [{
        params ["_args", "_handle"];
        _args params ["_missile", "_target", "_state", "_turret", "_engageId"];

        private _dead = isNull _missile
            || {!alive _missile}
            || {isNull _target}
            || {!alive _target}
            || {CBA_missionTime > (_state get "deadline")};

        if (_dead) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
            [_turret, true, _engageId] call PHEN_ADP_fnc_endEngage;
            if (!isNull _missile && {alive _missile}) then {triggerAmmo _missile};
        };

        private _missilePos = getPosASL _missile;
        private _targetPos = getPosASL _target;
        private _lineOfSight = _targetPos vectorDiff _missilePos;
        private _distance = vectorMagnitude _lineOfSight;

        if (_distance <= (_state get "fuze")) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
            [_turret, true, _engageId] call PHEN_ADP_fnc_endEngage;
            [_target, _missile] call PHEN_ADP_fnc_intercept;
        };

        private _closest = _state get "closest";
        if (_distance < _closest) then {
            _state set ["closest", _distance];
            _closest = _distance;
        };

        private _missed = _distance > (_closest + 120) && {CBA_missionTime > (_state get "armed")};
        if (_missed) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
            [_turret, true, _engageId] call PHEN_ADP_fnc_endEngage;
            _target setVariable ["PHEN_ADP_lockedUntil", 0];
            triggerAmmo _missile;
        }; //120m away from closest point is a miss mostly

        if (_state get "engine") exitWith {
            private _proxy = _state get "proxy";

            if ((vehicle (missileTarget _missile)) isEqualTo _proxy) then {
                _state set ["held", true];
                _state set ["fails", 0];
            } else {
                _missile setMissileTarget [_proxy, true];

                if !(_state get "held") then {
                    private _fails = (_state get "fails") + 1;
                    _state set ["fails", _fails];
                    if (_fails > 3) then {_state set ["engine", false]};
                };
            };
        };

        private _now = CBA_missionTime;
        private _frameTime = ((_now - (_state get "lastTick")) max 0.001) min 0.1;
        _state set ["lastTick", _now];

        private _top = _state get "top";
        private _speed = ((_state get "commanded") + ((_top / 2) * _frameTime)) min _top;
        _state set ["commanded", _speed];

        private _missileVelocity = velocity _missile;
        private _targetVelocity = velocity _target;
        private _closingSpeed = (vectorMagnitude (_targetVelocity vectorDiff _missileVelocity)) max 1;
        private _timeToGo = (_distance / _closingSpeed) min 7;
        private _wanted = vectorNormalized (_lineOfSight vectorAdd (_targetVelocity vectorMultiply _timeToGo));

        private _current = vectorNormalized _missileVelocity;
        private _angle = acos (((_current vectorCos _wanted) min 1) max -1);
        private _maxTurn = 120 * _frameTime;   //120 deg/s
        private _steer = _wanted;
        if (_angle > _maxTurn) then {
            _steer = vectorNormalized (_current vectorAdd ((_wanted vectorDiff _current) vectorMultiply (_maxTurn / _angle)));
        };

        private _up = [0, 0, 1] vectorDiff (_steer vectorMultiply (_steer select 2));
        if ((vectorMagnitude _up) < 0.01) then {_up = [0, 1, 0]};

        _missile setVectorDirAndUp [_steer, vectorNormalized _up];
        _missile setVelocity (_steer vectorMultiply _speed);
    }, 0.01, [_missile, _target, _state, _turret, _engageId]] call CBA_fnc_addPerFrameHandler;
};

// resolve one intercept; if failed accuracy rollchance EXITwith
PHEN_ADP_fnc_intercept = {
    params [["_threat", objNull, [objNull]], ["_interceptor", objNull, [objNull]]];

    if (!isServer) exitWith {};
    if (isNull _threat || {!alive _threat}) exitWith {};

    //rolled a miss? == round is free to blow up in le sky
    if (random 1 > PHEN_ADP_accuracy) exitWith {
        _threat setVariable ["PHEN_ADP_lockedUntil", 0];

        private _flyOn = !isNull _interceptor && {alive _interceptor};
        if (_flyOn) then {_interceptor setMissileTarget [objNull, true]};
    };

    private _position = getPosASL _threat;
    if (!isNull _interceptor && {alive _interceptor}) then {triggerAmmo _interceptor};

    private _index = PHEN_ADP_threats find _threat;
    if (_index isNotEqualTo -1) then {PHEN_ADP_threats deleteAt _index};

    private _isDrone = (_threat getVariable ["PHEN_ADP_cat", 0]) isEqualTo PHEN_ADP_CAT_DRONE;
    if (_isDrone) then {
        _threat setDamage 0.99;
    } else {
        deleteVehicle _threat;
    };

    private _burst = createVehicle [selectRandom PHEN_ADP_BURST_CLASSES, ASLToAGL _position, [], 0, "CAN_COLLIDE"];
    triggerAmmo _burst;
};

// sound incoming siren
PHEN_ADP_fnc_alarm = {
    params [["_turret", objNull, [objNull]]];

    if (!PHEN_ADP_alarmEnabled) exitWith {};
    if (isNull _turret) exitWith {};
    if !(_turret getVariable ["PHEN_ADP_alarm", true]) exitWith {};

    private _now = CBA_missionTime;
    private _last = _turret getVariable ["PHEN_ADP_alarmTime", -100000];
    if ((_now - _last) < 60) exitWith {};

    PHEN_ADP_alarmsSounding = PHEN_ADP_alarmsSounding select {(_x select 1) > _now};
    private _pos = getPosASL _turret;
    private _heard = PHEN_ADP_alarmsSounding findIf {(_x select 0) distance _pos < 600};
    if (_heard isNotEqualTo -1) exitWith {};

    _turret setVariable ["PHEN_ADP_alarmTime", _now];
    PHEN_ADP_alarmsSounding pushBack [_pos, _now + PHEN_ADP_ALARM_LENGTH];

    private _speakers = [];
    {
        private _found = _turret nearObjects [_x, 300];
        _speakers append (_found select {alive _x});
    } forEach PHEN_ADP_SPEAKER_CLASSES;

    ["PHEN_ADP_alarm", [_turret, _speakers]] call CBA_fnc_globalEvent;
};

PHEN_ADP_fnc_playAlarm = {
    params [["_turret", objNull, [objNull]], ["_speakers", [], [[]]]];

    if (!hasInterface) exitWith {};
    if (isNull _turret) exitWith {};

    private _file = "\PHEN_ADP\sounds\PHEN_ADP_alarm.ogg";
    private _live = _speakers select {!isNull _x && {alive _x}};

    if (_live isEqualTo []) exitWith {
        playSound3D [_file, _turret, false, getPosASL _turret, 2, 1, 1200];
    };

    {
        playSound3D [_file, _x, false, getPosASL _x, 2, 1, 1200];
    } forEach _live;
};

PHEN_ADP_fnc_setState = {
    params [["_turret", objNull, [objNull]], ["_key", "", [""]], ["_value", 0]];

    if (!isServer) exitWith {};
    if (isNull _turret) exitWith {};
    if !(_key in ["PHEN_ADP_mode", "PHEN_ADP_alarm"]) exitWith {};

    _turret setVariable [_key, _value, true];

    ["PHEN_ADP_stateChanged", [_turret]] call CBA_fnc_globalEvent;
};

PHEN_ADP_fnc_statusText = {
    params [["_turret", objNull, [objNull]], ["_action", "mode", [""]]];

    if (isNull _turret) exitWith {""};

    private _icon = ((typeOf _turret) call PHEN_ADP_fnc_getConfigSetup) get "icon";

    if (_action isEqualTo "alarm") exitWith {
        private _on = _turret getVariable ["PHEN_ADP_alarm", true];
        private _colour = PHEN_ADP_COLOR_OFF;
        private _label = localize "STR_PHEN_ADP_State_Off";
        if (_on) then {
            _colour = PHEN_ADP_COLOR_ON;
            _label = localize "STR_PHEN_ADP_State_On";
        };
        format [
            "<img image='%1' size='1' /> <t color='%2'>%3</t>   <t color='%4'>%5</t>",
            _icon, PHEN_ADP_COLOR_TITLE, localize "STR_PHEN_ADP_Action_Alarm", _colour, _label
        ]
    };

    private _mode = _turret getVariable ["PHEN_ADP_mode", 0];
    private _colour = PHEN_ADP_COLOR_ON;
    if (_mode isEqualTo 0) then {_colour = PHEN_ADP_COLOR_OFF};

    format [
        "<img image='%1' size='1' /> <t color='%2'>%3</t>   <t color='%4'>%5</t>",
        _icon, PHEN_ADP_COLOR_TITLE, localize "STR_PHEN_ADP_Action_AirDefense", _colour, (PHEN_ADP_MODE_NAMES select _mode)
    ]
};

//adds two scroll actions keeps ids so text can be rewritten later
PHEN_ADP_fnc_addActions = {
    params [["_turret", objNull, [objNull]]];

    if (!hasInterface) exitWith {};
    if (!PHEN_ADP_scrollActions) exitWith {};
    if (isNull _turret) exitWith {};
    if (!isNil {_turret getVariable "PHEN_ADP_actionIds"}) exitWith {};

    private _condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]} && {!(_this in _target)}";

    private _modeId = _turret addAction [
        [_turret, "mode"] call PHEN_ADP_fnc_statusText,
        {
            params ["_target"];
            private _mode = ((_target getVariable ["PHEN_ADP_mode", 0]) + 1) % 4;
            ["PHEN_ADP_setState", [_target, "PHEN_ADP_mode", _mode]] call CBA_fnc_serverEvent;
        },
        nil, 6, false, true, "", _condition, PHEN_ADP_ACTION_DISTANCE
    ];

    private _alarmId = _turret addAction [
        [_turret, "alarm"] call PHEN_ADP_fnc_statusText,
        {
            params ["_target"];
            private _on = !(_target getVariable ["PHEN_ADP_alarm", true]);
            ["PHEN_ADP_setState", [_target, "PHEN_ADP_alarm", _on]] call CBA_fnc_serverEvent;
        },
        nil, 5, false, true, "", _condition, PHEN_ADP_ACTION_DISTANCE
    ];

    _turret setVariable ["PHEN_ADP_actionIds", [_modeId, _alarmId]];

    [{["PHEN_ADP_stateChanged", _this] call CBA_fnc_localEvent}, [_turret], 2] call CBA_fnc_waitAndExecute;
};
