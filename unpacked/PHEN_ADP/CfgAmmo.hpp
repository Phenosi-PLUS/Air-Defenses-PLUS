class CfgAmmo {
	class SmallSecondary;

	//burst has to be big Big, a in-flight misile needs to be hit and they be hella fast
	class PHEN_ADP_InterceptBurst: SmallSecondary {
		hit = 60;
		indirectHit = 40;
		indirectHitRange = 16;
		dangerRadiusHit = -1;
		suppressionRadiusHit = -1;
	};
	//just diff variants
	class PHEN_ADP_InterceptBurst_Heli: PHEN_ADP_InterceptBurst {
		explosionEffects = "HelicopterExplosionEffects";
	};

	class PHEN_ADP_InterceptBurst_AA: PHEN_ADP_InterceptBurst {
		explosionEffects = "AAMissileExplosion";
	};
};
