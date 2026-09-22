class CfgPatches {
	class PHEN_ADP {
		name = "Air Defenses PLUS";

		author = "Phenosi";
		url = "https://discord.gg/7zSXScbRCQ";
		requiredVersion = 1.0;

		version = 1.0.0;
		versionStr = "1.0.0";
		versionAr[] = {1,0,0};

		requiredAddons[] = {
			"cba_settings",
			"cba_xeh",
			"cba_ai",
			"A3_Static_F_Jets_AAA_System_01",
			"A3_Static_F_Jets_SAM_System_01",
			"A3_Static_F_Jets_SAM_System_02"
		};

		units[] = {
			"PHEN_ADP_TargetProxy_B",
			"PHEN_ADP_TargetProxy_O",
			"PHEN_ADP_TargetProxy_I"
		};
		weapons[] = {};
	};
};

class CfgSettings {
	class CBA {
		class Versioning {
			class PHEN_ADP {
				main_addon = "PHEN_ADP";
				class Dependencies {
					CBA[] = {"cba_main",{3,15,0},"true"};
				};
			};
		};
	};
};

//Includes bc we like an organized structure :))
#include "CfgEventHandlers.hpp"
#include "CfgAmmo.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"