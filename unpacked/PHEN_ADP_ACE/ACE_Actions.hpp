class PHEN_ADP_ModeOff {
	displayName = "$STR_PHEN_ADP_ACE_ModeOff";
	condition = "((_target getVariable ['PHEN_ADP_mode', 0]) != 0)";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 5;
};
class PHEN_ADP_ModeRandom {
	displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
	condition = "((_target getVariable ['PHEN_ADP_mode', 0]) != 1)";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 4;
};
class PHEN_ADP_ModeClosest {
	displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
	condition = "((_target getVariable ['PHEN_ADP_mode', 0]) != 2)";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 3;
};
class PHEN_ADP_ModeHighest {
	displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
	condition = "((_target getVariable ['PHEN_ADP_mode', 0]) != 3)";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 2;
};
class PHEN_ADP_AlarmOn {
	displayName = "$STR_PHEN_ADP_ACE_AlarmOn";
	condition = "!(_target getVariable ['PHEN_ADP_alarm', true])";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', true]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 1;
};
class PHEN_ADP_AlarmOff {
	displayName = "$STR_PHEN_ADP_ACE_AlarmOff";
	condition = "(_target getVariable ['PHEN_ADP_alarm', true])";
	statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', false]] call CBA_fnc_serverEvent;";
	exceptions[] = {"isNotSwimming"};
	priority = 1;
};
