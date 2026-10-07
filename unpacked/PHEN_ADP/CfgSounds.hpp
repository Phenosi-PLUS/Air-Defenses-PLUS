class CfgSounds {
	//PHEN_ADP_alarm = 1 puts it in the side alarm lists, playAlarm reads volume and range off sound[]
	//duration is the ogg length in seconds rounded up, the alarm cooldown only starts after it
	//db value is per file, brings every alarm to about -10 LUFS so none plays louder than the rest
	class PHEN_ADP_Alarm_CRAM {
		name = "PHEN_ADP_Alarm_CRAM";
		displayName = "$STR_PHEN_ADP_Alarm_CRAM";
		sound[] = {"\PHEN_ADP\sounds\PHEN_ADP_alarm.ogg", db-5, 1, 1200};
		titles[] = {0, ""};
		duration = 7;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_GeneralQuarters {
		name = "PHEN_ADP_Alarm_GeneralQuarters";
		displayName = "$STR_PHEN_ADP_Alarm_GeneralQuarters";
		sound[] = {"\PHEN_ADP\sounds\general_quarters_01.ogg", db+2, 1, 1200};
		titles[] = {0, ""};
		duration = 30;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_Thunderbolt {
		name = "PHEN_ADP_Alarm_Thunderbolt";
		displayName = "$STR_PHEN_ADP_Alarm_Thunderbolt";
		sound[] = {"\PHEN_ADP\sounds\CIV_US_ColdWar_FederalSignal_Thunderbolt_1000T.ogg", db+4, 1, 1200};
		titles[] = {0, ""};
		duration = 53;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_S40 {
		name = "PHEN_ADP_Alarm_S40";
		displayName = "$STR_PHEN_ADP_Alarm_S40";
		sound[] = {"\PHEN_ADP\sounds\RUS_TypeS40.ogg", db+14, 1, 1200};
		titles[] = {0, ""};
		duration = 33;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_RusNaval {
		name = "PHEN_ADP_Alarm_RusNaval";
		displayName = "$STR_PHEN_ADP_Alarm_RusNaval";
		sound[] = {"\PHEN_ADP\sounds\RUS_AlarmOnANavalShip.ogg", db+7, 1, 1200};
		titles[] = {0, ""};
		duration = 20;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_E57 {
		name = "PHEN_ADP_Alarm_E57";
		displayName = "$STR_PHEN_ADP_Alarm_E57";
		sound[] = {"\PHEN_ADP\sounds\GER_E57_siren_luftalarm.ogg", db+1, 1, 1200};
		titles[] = {0, ""};
		duration = 30;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_WW2_1 {
		name = "PHEN_ADP_Alarm_WW2_1";
		displayName = "$STR_PHEN_ADP_Alarm_WW2_1";
		sound[] = {"\PHEN_ADP\sounds\WW2_AirRaid_Siren_V1.ogg", db+5, 1, 1200};
		titles[] = {0, ""};
		duration = 27;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_WW2_2 {
		name = "PHEN_ADP_Alarm_WW2_2";
		displayName = "$STR_PHEN_ADP_Alarm_WW2_2";
		sound[] = {"\PHEN_ADP\sounds\WW2_AirRaid_Siren_V2.ogg", db+4, 1, 1200};
		titles[] = {0, ""};
		duration = 23;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_Singapore {
		name = "PHEN_ADP_Alarm_Singapore";
		displayName = "$STR_PHEN_ADP_Alarm_Singapore";
		sound[] = {"\PHEN_ADP\sounds\Singapore_SignalSirenAlarm_ECN_1200ogg.ogg", db+8, 1, 1200};
		titles[] = {0, ""};
		duration = 71;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_Evacuation {
		name = "PHEN_ADP_Alarm_Evacuation";
		displayName = "$STR_PHEN_ADP_Alarm_Evacuation";
		sound[] = {"\PHEN_ADP\sounds\AUS_EvacuationTone_TF036.ogg", db-3, 1, 1200};
		titles[] = {0, ""};
		duration = 6;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_IndustrialKlaxon {
		name = "PHEN_ADP_Alarm_IndustrialKlaxon";
		displayName = "$STR_PHEN_ADP_Alarm_IndustrialKlaxon";
		sound[] = {"\PHEN_ADP\sounds\IndustrialClaxon_TF046.ogg", db+1, 1, 1200};
		titles[] = {0, ""};
		duration = 9;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_DiveKlaxon {
		name = "PHEN_ADP_Alarm_DiveKlaxon";
		displayName = "$STR_PHEN_ADP_Alarm_DiveKlaxon";
		sound[] = {"\PHEN_ADP\sounds\Submarine_divingAlarmSoundEffect.ogg", db-7, 1, 1200};
		titles[] = {0, ""};
		duration = 11;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_Bell {
		name = "PHEN_ADP_Alarm_Bell";
		displayName = "$STR_PHEN_ADP_Alarm_Bell";
		sound[] = {"\PHEN_ADP\sounds\MechanicalBell_TF050.ogg", db+1, 1, 1200};
		titles[] = {0, ""};
		duration = 8;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_Blaring {
		name = "PHEN_ADP_Alarm_SciFi_Blaring";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_Blaring";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_01_Blaring.ogg", db+10, 1, 1200};
		titles[] = {0, ""};
		duration = 15;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_Screeching {
		name = "PHEN_ADP_Alarm_SciFi_Screeching";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_Screeching";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_02_Screeching.ogg", db+6, 1, 1200};
		titles[] = {0, ""};
		duration = 11;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_Panic {
		name = "PHEN_ADP_Alarm_SciFi_Panic";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_Panic";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_03_Panic.ogg", db+4, 1, 1200};
		titles[] = {0, ""};
		duration = 4;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_DeepSiren {
		name = "PHEN_ADP_Alarm_SciFi_DeepSiren";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_DeepSiren";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_04_DeepSiren.ogg", db+2, 1, 1200};
		titles[] = {0, ""};
		duration = 7;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_Industrial {
		name = "PHEN_ADP_Alarm_SciFi_Industrial";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_Industrial";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_05_Industrial.ogg", db+8, 1, 1200};
		titles[] = {0, ""};
		duration = 4;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_ReactorUnstable {
		name = "PHEN_ADP_Alarm_SciFi_ReactorUnstable";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_ReactorUnstable";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_06_ReactorUnstable.ogg", db+9, 1, 1200};
		titles[] = {0, ""};
		duration = 14;
		PHEN_ADP_alarm = 1;
	};
	class PHEN_ADP_Alarm_SciFi_Attention {
		name = "PHEN_ADP_Alarm_SciFi_Attention";
		displayName = "$STR_PHEN_ADP_Alarm_SciFi_Attention";
		sound[] = {"\PHEN_ADP\sounds\SCIFI_Alarm_07_Attention.ogg", db+4, 1, 1200};
		titles[] = {0, ""};
		duration = 4;
		PHEN_ADP_alarm = 1;
	};
};
