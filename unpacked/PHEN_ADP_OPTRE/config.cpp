class CfgPatches {
	class PHEN_ADP_OPTRE {
		name = "Air Defenses PLUS, OPTRE Compatibility";
		author = "Phenosi";
		units[] = {};
		weapons[] = {};
		requiredVersion = 2.10;
		requiredAddons[] = {"PHEN_ADP", "Lance", "OPTRE_Weapons_Turrets_C9_SAM"}; // Skip if OPTRE is not loaded

		//Scythe needs nothing bc its a gun based on Phalanx
		skipWhenMissingDependencies = 1;
	};
};

class CfgVehicles {
	class StaticMGWeapon;
	class AAA_System_01_base_F: StaticMGWeapon {
		class PHEN_ADP;
	};

	//missile launcher mode for Lance, bc based on Phalanx which thinks is a gun in the mod
	class OPTRE_Lance: AAA_System_01_base_F {
		class PHEN_ADP: PHEN_ADP {
			mode = "missile";
			range = 2500;
			needsAiming = 0;
			shotDelay = 5;
			fuzeRadius = 9;
		};
	};

	class OPTRE_C9_SAM_LR_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "missile";
			range = 16000;
			needsAiming = 1;
			shotDelay = 4;
			fuzeRadius = 30;
		};
	};

	class OPTRE_C9_SAM_SR_Base_F: OPTRE_C9_SAM_LR_base_F {
		class PHEN_ADP: PHEN_ADP {
			range = 4000;
			fuzeRadius = 20;
			bombs = 1;
		};
	};

	class OPTRE_C9_RA_base_F: OPTRE_C9_SAM_LR_base_F {
		class PHEN_ADP: PHEN_ADP {
			enabled = 0;
		};
	};
};
