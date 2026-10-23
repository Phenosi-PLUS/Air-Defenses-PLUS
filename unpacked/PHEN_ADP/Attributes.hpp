class Cfg3DEN {
	class Object {
		class AttributeCategories {
			class PHEN_ADP {
				displayName = "Air Defenses PLUS";
				collapsed = 1;
				class Attributes {
					class PHEN_ADP_edenOn {
						displayName = "$STR_PHEN_ADP_Eden_On";
						tooltip = "$STR_PHEN_ADP_Eden_On_Desc";
						property = "PHEN_ADP_edenOn";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "true";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenMode {
						displayName = "$STR_PHEN_ADP_Eden_Mode";
						tooltip = "$STR_PHEN_ADP_Eden_Mode_Desc";
						property = "PHEN_ADP_edenMode";
						control = "Combo";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "-1";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "NUMBER";
						class Values {
							class SettingsDefault {
								name = "$STR_PHEN_ADP_Eden_ModeDefault";
								value = -1;
							};
							class Random {
								name = "$STR_PHEN_ADP_Mode_Random";
								value = 1;
							};
							class Closest {
								name = "$STR_PHEN_ADP_Mode_Closest";
								value = 2;
							};
							class Highest {
								name = "$STR_PHEN_ADP_Mode_Highest";
								value = 3;
							};
						};
					};
					class PHEN_ADP_edenAlarm {
						displayName = "$STR_PHEN_ADP_AlarmEnabled";
						tooltip = "$STR_PHEN_ADP_Eden_Alarm_Desc";
						property = "PHEN_ADP_edenAlarm";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "true";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenBallistic {
						displayName = "$STR_PHEN_ADP_TrackBallistic";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenBallistic";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('artillery' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenSubmunition {
						displayName = "$STR_PHEN_ADP_TrackSubmunition";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenSubmunition";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('rocketarty' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenMissile {
						displayName = "$STR_PHEN_ADP_TrackMissile";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenMissile";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('missiles' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenRocket {
						displayName = "$STR_PHEN_ADP_TrackRocket";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenRocket";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('rockets' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenBombs {
						displayName = "$STR_PHEN_ADP_TrackBombs";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenBombs";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "((isArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) && { !('bombs' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x })) })";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenDrones {
						displayName = "$STR_PHEN_ADP_TrackDrones";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenDrones";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('drones' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
					class PHEN_ADP_edenCinematic {
						displayName = "$STR_PHEN_ADP_ShootCinematic";
						tooltip = "$STR_PHEN_ADP_Eden_Threat_Desc";
						property = "PHEN_ADP_edenCinematic";
						control = "Checkbox";
						expression = "_this setVariable ['%s', _value];";
						defaultValue = "!('cinematic' in ((getArray (configOf _this >> 'PHEN_ADP' >> 'ignore')) apply { toLower _x }))";
						condition = "objectVehicle * script";
						conditionScript = "((getNumber (configOf _this >> 'PHEN_ADP' >> 'enabled')) isEqualTo 1)";
						typeName = "BOOL";
					};
				};
			};
		};
	};
};
