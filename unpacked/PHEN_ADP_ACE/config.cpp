class CfgPatches {
	class PHEN_ADP_ACE {
		name = "Air Defenses PLUS, ACE Interaction Compatibility";
		author = "Phenosi";
		units[] = {};
		weapons[] = {};
		requiredVersion = 2.10;
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
	class LandVehicle;
	class StaticWeapon: LandVehicle {
		class ACE_Actions {
			class ACE_MainActions;
		};
	};
	class StaticMGWeapon: StaticWeapon {};

	class AAA_System_01_base_F: StaticMGWeapon {
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions: ACE_MainActions {
				class PHEN_ADP_Root {
					displayName = "$STR_PHEN_ADP_ACE_Root";
					icon = "\A3\Static_F_Jets\AAA_system_01\Data\UI\AAA_system_01_icon_CA.paa";
					condition = "alive _target && {_target getVariable ['PHEN_ADP_registered', false]}";
					// statement = "true";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					#include "ACE_Actions.hpp"
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
					// statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					#include "ACE_Actions.hpp"
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
					// statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					#include "ACE_Actions.hpp"
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
					// statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					#include "ACE_Actions.hpp"
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
					// statement = "";
					exceptions[] = {"isNotSwimming"};
					priority = 2.5;
					#include "ACE_Actions.hpp"
				};
			};
		};
	};
};
