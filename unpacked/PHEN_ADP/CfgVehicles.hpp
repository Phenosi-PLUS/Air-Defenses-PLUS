class CfgVehicles {
	class CBA_B_InvisibleTargetAir;
	class CBA_O_InvisibleTargetAir;
	class CBA_I_InvisibleTargetAir;

	class PHEN_ADP_TargetProxy_B: CBA_B_InvisibleTargetAir {
		author = "Phenosi";
		displayName = "$STR_PHEN_ADP_TargetProxy";

		vehicleClass = "Air";
		type = 2;
		scope = 1;
		scopeCurator = 0;
		scopeArsenal = 0;
		allowTabLock = 1;
		canUseScanner = 1;
		irScanToEyeFactor = 5;
		irScanRangeMin = 5;
		irScanRangeMax = 5000;
		irScanGround = 1;
		irTarget = 1;
		irTargetSize = 2.0;
		laserScanner = 1;
		laserTarget = 0;
		weaponLockSystem = "2 + 4 + 8 + 16";
		nvScanner = 1;
		radarType = 4;
		radarTarget = 1;
		radarTargetSize = 2.0;
		receiveRemoteTargets = 1;
		reportRemoteTargets = 1;
		reportOwnPosition = 1;
		showAllTargets = 2;
		lockDetectionSystem = "2 + 4 + 8 + 16";
		incomingMissileDetectionSystem = "2 + 4 + 8 + 16";
	};

	class PHEN_ADP_TargetProxy_O: CBA_O_InvisibleTargetAir {
		author = "Phenosi";
		displayName = "$STR_PHEN_ADP_TargetProxy";
		scope = 1;
		scopeCurator = 0;
		scopeArsenal = 0;
		vehicleClass = "Air";
		type = 2;
		scope = 1;
		scopeCurator = 0;
		scopeArsenal = 0;
		allowTabLock = 1;
		canUseScanner = 1;
		irScanToEyeFactor = 5;
		irScanRangeMin = 5;
		irScanRangeMax = 5000;
		irScanGround = 1;
		irTarget = 1;
		irTargetSize = 2.0;
		laserScanner = 1;
		laserTarget = 0;
		weaponLockSystem = "2 + 4 + 8 + 16";
		nvScanner = 1;
		radarType = 4;
		radarTarget = 1;
		radarTargetSize = 2.0;
		receiveRemoteTargets = 1;
		reportRemoteTargets = 1;
		reportOwnPosition = 1;
		showAllTargets = 2;
		lockDetectionSystem = "2 + 4 + 8 + 16";
		incomingMissileDetectionSystem = "2 + 4 + 8 + 16";	
	};

	class PHEN_ADP_TargetProxy_I: CBA_I_InvisibleTargetAir {
		author = "Phenosi";
		displayName = "$STR_PHEN_ADP_TargetProxy";
		scope = 1;
		scopeCurator = 0;
		scopeArsenal = 0;
		vehicleClass = "Air";
		type = 2;
		scope = 1;
		scopeCurator = 0;
		scopeArsenal = 0;
		allowTabLock = 1;
		canUseScanner = 1;
		irScanToEyeFactor = 5;
		irScanRangeMin = 5;
		irScanRangeMax = 5000;
		irScanGround = 1;
		irTarget = 1;
		irTargetSize = 2.0;
		laserScanner = 1;
		laserTarget = 0;
		weaponLockSystem = "2 + 4 + 8 + 16";
		nvScanner = 1;
		radarType = 4;
		radarTarget = 1;
		radarTargetSize = 2.0;
		receiveRemoteTargets = 1;
		reportRemoteTargets = 1;
		reportOwnPosition = 1;
		showAllTargets = 2;
		lockDetectionSystem = "2 + 4 + 8 + 16";
		incomingMissileDetectionSystem = "2 + 4 + 8 + 16";	
	};

	class StaticMGWeapon;

	/*
		class PHEN_ADP is the ADP config setup block. Any air defense that inherits one of the base
		classes below is picked up. Other modders *CAN declare their own by adding the same block to their vehicle, see the wiki.

		mode              "gun" or "missile"
		range             engagement radius in meters
		needsAiming       1 when the launcher has to be pointed before it will fire
		shotDelay         seconds between shots
		fuzeRadius        proximity fuze radius in meters

		an 'interceptor' gets given its target with setMissileTarget and the engine flies it on its own
		Ammo that does not take a lock gets moved via script
	*/
	class AAA_System_01_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "gun";
			range = 2800;
			shotDelay = 3;
		};
	};

	class SAM_System_01_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "missile";
			range = 3500;
			needsAiming = 0;
			shotDelay = 0.85;
			fuzeRadius = 9;
		};
	};

	class SAM_System_02_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "missile";
			range = 7000;
			needsAiming = 1;
			shotDelay = 3;
			fuzeRadius = 15;
		};
	};

	class SAM_System_03_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "missile";
			range = 9600;
			needsAiming = 1;
			shotDelay = 4;
			fuzeRadius = 30;
		};
	};

	class SAM_System_04_base_F: StaticMGWeapon {
		class PHEN_ADP {
			enabled = 1;
			mode = "missile";
			range = 9600;
			needsAiming = 1;
			shotDelay = 4;
			fuzeRadius = 30;
		};
	};
};
