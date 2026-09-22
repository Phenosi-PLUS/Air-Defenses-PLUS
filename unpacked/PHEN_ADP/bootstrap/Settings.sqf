//MOD SETINGS / Settings.sqf
    // CBA settings for Air Defenses PLUS. 
    // EVERY SETINGS is server forced, kepp that in mind
// except PHEN_ADP_debug, that one is client-side

[
    "PHEN_ADP_enabled",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_Enabled", localize "STR_PHEN_ADP_Enabled_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_defaultModeGun",
    "LIST",
    [localize "STR_PHEN_ADP_DefaultModeGun", localize "STR_PHEN_ADP_DefaultModeGun_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    [[0,1,2,3], PHEN_ADP_MODE_NAMES, 2],
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_defaultModeMissile",
    "LIST",
    [localize "STR_PHEN_ADP_DefaultModeMissile", localize "STR_PHEN_ADP_DefaultModeMissile_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    [[0,1,2,3], PHEN_ADP_MODE_NAMES, 3],
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_pauseWhenCrewed",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_PauseWhenCrewed", localize "STR_PHEN_ADP_PauseWhenCrewed_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_friendlyFire",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_FriendlyFire", localize "STR_PHEN_ADP_FriendlyFire_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    false,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_extraClasses",
    "EDITBOX",
    [localize "STR_PHEN_ADP_ExtraClasses", localize "STR_PHEN_ADP_ExtraClasses_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_General"],
    "[]",
    1,
    {},
    true
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_trackBallistic",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_TrackBallistic", localize "STR_PHEN_ADP_TrackBallistic_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Threats"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_trackSubmunition",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_TrackSubmunition", localize "STR_PHEN_ADP_TrackSubmunition_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Threats"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_trackMissile",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_TrackMissile", localize "STR_PHEN_ADP_TrackMissile_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Threats"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_trackRocket",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_TrackRocket", localize "STR_PHEN_ADP_TrackRocket_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Threats"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_trackDrones",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_TrackDrones", localize "STR_PHEN_ADP_TrackDrones_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Threats"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_rangeMultiplier",
    "SLIDER",
    [localize "STR_PHEN_ADP_RangeMultiplier", localize "STR_PHEN_ADP_RangeMultiplier_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Tuning"],
    [0.25, 2, 1, 2],
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_accuracy",
    "SLIDER",
    [localize "STR_PHEN_ADP_Accuracy", localize "STR_PHEN_ADP_Accuracy_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Tuning"],
    [0, 1, 0.85, 2, true],
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_alarmEnabled",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_AlarmEnabled", localize "STR_PHEN_ADP_AlarmEnabled_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Alarm"],
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "PHEN_ADP_scrollActions",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_ScrollActions", localize "STR_PHEN_ADP_ScrollActions_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Interface"],
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

//ONLY clientside setting
[
    "PHEN_ADP_debug",
    "CHECKBOX",
    [localize "STR_PHEN_ADP_Debug", localize "STR_PHEN_ADP_Debug_Desc"],
    ["Air Defenses PLUS", localize "STR_PHEN_ADP_Cat_Interface"],
    false,
    0,
    {
        if (isNil "PHEN_ADP_fnc_debugStart") exitWith {};
        if (_this) then { call PHEN_ADP_fnc_debugStart } else { call PHEN_ADP_fnc_debugStop };
    }
] call CBA_fnc_addSetting;
