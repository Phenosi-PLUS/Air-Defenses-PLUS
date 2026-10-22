class CfgPatches {
	class PHEN_ADP_OPTRE_FC {
		name = "Air Defenses PLUS, OPTRE First Contact Compatibility";
		author = "Phenosi";
		units[] = {};
		weapons[] = {};
		requiredVersion = 2.10;
		requiredAddons[] = {"PHEN_ADP", "OPTRE_FC_Weapons_Shade", "OPTRE_FC_Weapons_Draugr", "OPTRE_FC_Weapons_Tyrant", "OPTRE_FC_Scarab"};
		// Skip if OPTRE FC is not loaded
		skipWhenMissingDependencies = 1;
	};
}; //for all BUT Shrike and Tyrant

class CfgVehicles {
	class StaticMGWeapon;
	class AAA_System_01_base_F: StaticMGWeapon {
		class PHEN_ADP;
	};
	class OPTRE_FC_Tyrant: AAA_System_01_base_F {};
	class OPTRE_FC_Tyrant_StandAlone: OPTRE_FC_Tyrant {};
	class OPTRE_FC_T26_AI;

	class OPTRE_FC_T26_AA: OPTRE_FC_T26_AI {
		class PHEN_ADP {
			enabled = 1;
			mode = "gun";
			range = 2500;
			shotDelay = 2;
			ignore[] = {};
		};
	};

	class OPTRE_FC_T29B_NVar: AAA_System_01_base_F {
		class PHEN_ADP: PHEN_ADP {
			enabled = 1;
			range = 1500;
		};
	};

	//missile launcher mode bc it does Praetorian base even tho issa missile thing
	class OPTRE_FC_T29N_SAM: AAA_System_01_base_F {
		class PHEN_ADP: PHEN_ADP {
			mode = "missile";
			range = 7500;
			needsAiming = 1;
			shotDelay = 4;
			fuzeRadius = 30;
			ignore[] = {"bombs"};
		};
	};

	//FakeWeapon only; still inheirted the base
	class OPTRE_FC_T29R_Radar: AAA_System_01_base_F {
		class PHEN_ADP: PHEN_ADP {
			enabled = 0;
		};
	};

	class OPTRE_FC_Tlauncher: OPTRE_FC_Tyrant_StandAlone {
		class PHEN_ADP: PHEN_ADP {
			enabled = 0;
		};
	}; 	//cruise torpedoes which are wayy too big for 'interceptor' typical things

	//scarab legs are Praetorians too?! xd
	class OPTRE_FC_extras_base: AAA_System_01_base_F {
		class PHEN_ADP: PHEN_ADP {
			enabled = 0;
		};
	};
};
