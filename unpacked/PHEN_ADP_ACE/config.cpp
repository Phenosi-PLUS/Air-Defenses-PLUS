class CfgPatches {
	class PHEN_ADP_ACE {
		name = "Air Defenses PLUS, ACE Interaction Compatibility";
		author = "Phenosi";
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"PHEN_ADP", "ace_interaction"};
		// skip if not loaded etc, OPTIONAL PBO, can stay in an aux finee
		skipWhenMissingDependencies = 1;
	};
};

class Extended_PreInit_EventHandlers {
	class PHEN_ADP_ACE_PreInit {
		init = "call compile preprocessFileLineNumbers '\PHEN_ADP_ACE\bootstrap\XEH_preInit.sqf'";
	};
};

class CfgVehicles {
	class StaticMGWeapon {
		class ACE_Actions {
			class ACE_MainActions;
		};
	};

	class AAA_System_01_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Jets\AAA_system_01\Data\UI\AAA_system_01_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					class PHEN_ADP_ModeOff {
						displayName = "$STR_PHEN_ADP_ACE_ModeOff";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 5;
					};
					class PHEN_ADP_ModeRandom {
						displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 4;
					};
					class PHEN_ADP_ModeClosest {
						displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 3;
					};
					class PHEN_ADP_ModeHighest {
						displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 2;
					};
					class PHEN_ADP_AlarmToggle {
						displayName = "$STR_PHEN_ADP_ACE_AlarmToggle";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', !(_target getVariable ['PHEN_ADP_alarm', true])]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 1;
					};
				};
			};
		};
	};

	class SAM_System_01_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Jets\SAM_System_01\Data\UI\SAM_System_01_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					class PHEN_ADP_ModeOff {
						displayName = "$STR_PHEN_ADP_ACE_ModeOff";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 5;
					};
					class PHEN_ADP_ModeRandom {
						displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 4;
					};
					class PHEN_ADP_ModeClosest {
						displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 3;
					};
					class PHEN_ADP_ModeHighest {
						displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 2;
					};
					class PHEN_ADP_AlarmToggle {
						displayName = "$STR_PHEN_ADP_ACE_AlarmToggle";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', !(_target getVariable ['PHEN_ADP_alarm', true])]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 1;
					};
				};
			};
		};
	};

	class SAM_System_02_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Jets\SAM_System_02\Data\UI\SAM_System_02_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					class PHEN_ADP_ModeOff {
						displayName = "$STR_PHEN_ADP_ACE_ModeOff";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 5;
					};
					class PHEN_ADP_ModeRandom {
						displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 4;
					};
					class PHEN_ADP_ModeClosest {
						displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 3;
					};
					class PHEN_ADP_ModeHighest {
						displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 2;
					};
					class PHEN_ADP_AlarmToggle {
						displayName = "$STR_PHEN_ADP_ACE_AlarmToggle";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', !(_target getVariable ['PHEN_ADP_alarm', true])]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 1;
					};
				};
			};
		};
	};

	class SAM_System_03_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Sams\SAM_System_03\Data\UI\SAM_System_03_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					class PHEN_ADP_ModeOff {
						displayName = "$STR_PHEN_ADP_ACE_ModeOff";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 5;
					};
					class PHEN_ADP_ModeRandom {
						displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 4;
					};
					class PHEN_ADP_ModeClosest {
						displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 3;
					};
					class PHEN_ADP_ModeHighest {
						displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 2;
					};
					class PHEN_ADP_AlarmToggle {
						displayName = "$STR_PHEN_ADP_ACE_AlarmToggle";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', !(_target getVariable ['PHEN_ADP_alarm', true])]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 1;
					};
				};
			};
		};
	};

	class SAM_System_04_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Sams\SAM_System_04\Data\UI\SAM_System_04_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					class PHEN_ADP_ModeOff {
						displayName = "$STR_PHEN_ADP_ACE_ModeOff";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 0]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 5;
					};
					class PHEN_ADP_ModeRandom {
						displayName = "$STR_PHEN_ADP_ACE_ModeRandom";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 1]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 4;
					};
					class PHEN_ADP_ModeClosest {
						displayName = "$STR_PHEN_ADP_ACE_ModeClosest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 2]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 3;
					};
					class PHEN_ADP_ModeHighest {
						displayName = "$STR_PHEN_ADP_ACE_ModeHighest";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_mode', 3]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 2;
					};
					class PHEN_ADP_AlarmToggle {
						displayName = "$STR_PHEN_ADP_ACE_AlarmToggle";
						condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
						statement = "['PHEN_ADP_setState', [_target, 'PHEN_ADP_alarm', !(_target getVariable ['PHEN_ADP_alarm', true])]] call CBA_fnc_serverEvent;";
						exceptions[] = {"isNotSwimming"};
						priority = 1;
					};
				};
			};
		};
	};
};
