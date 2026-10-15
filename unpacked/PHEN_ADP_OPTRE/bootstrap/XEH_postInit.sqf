// HEV pods go in as 'cinematic' targets once live
if (!isServer) exitWith {};
if (!PHEN_ADP_enabled) exitWith {};

PHEN_ADP_OPTRE_POD_WAIT = 300; //OPTRE pods give up at 300seconds
PHEN_ADP_OPTRE_POD_LAUNCH_SPEED = -5; //speed a goober still hanging undership is 0 
PHEN_ADP_OPTRE_pendingPods = [];
PHEN_ADP_OPTRE_podWatcher = -1;

["OPTRE_HEV", "initPost", {
    params ["_pod"];
    if (!PHEN_ADP_trackPods) exitWith {};
    if (PHEN_ADP_batteries isEqualTo []) exitWith {};

    PHEN_ADP_OPTRE_pendingPods pushBack [_pod, (CBA_missionTime + PHEN_ADP_OPTRE_POD_WAIT)];
    if (PHEN_ADP_OPTRE_podWatcher isNotEqualTo -1) exitWith {};

    PHEN_ADP_OPTRE_podWatcher = [{
        params ["_args", "_handle"];
        _now = CBA_missionTime;

        PHEN_ADP_OPTRE_pendingPods = PHEN_ADP_OPTRE_pendingPods select {
            _x params ["_pod", "_giveUpAt"];
            _launched = ((alive _pod)
                && { (isNull (attachedTo _pod)) }
                && { (((velocity _pod) select 2) < PHEN_ADP_OPTRE_POD_LAUNCH_SPEED) }
                && { (((getPos _pod) select 2) > PHEN_ADP_CINEMATIC_MIN_ALT) });

            if (_launched) then {
                _gunner = (gunner _pod);
                if (alive _gunner) then { [_pod, PHEN_ADP_CAT_CINEMATIC, (side (group _gunner))] call PHEN_ADP_fnc_addThreat };
            };
            ((alive _pod) && { !(_launched) } && { (_now < _giveUpAt) })
        };

        if (PHEN_ADP_OPTRE_pendingPods isEqualTo []) then {
            _handle call CBA_fnc_removePerFrameHandler;
            PHEN_ADP_OPTRE_podWatcher = -1;
        };
    }, 0.5, []] call CBA_fnc_addPerFrameHandler;
}, true, [], false] call CBA_fnc_addClassEventHandler;
