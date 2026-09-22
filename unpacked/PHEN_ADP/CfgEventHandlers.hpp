class Extended_PreInit_EventHandlers {
	class PHEN_ADP_PreInit_Constants {
		init = "call compile preprocessFileLineNumbers '\PHEN_ADP\bootstrap\Constants.sqf'";
	};
	class PHEN_ADP_PreInit_Functions {
		init = "call compile preprocessFileLineNumbers '\PHEN_ADP\bootstrap\Functions.sqf'";
	};
	class PHEN_ADP_PreInit_Settings {
		init = "call compile preprocessFileLineNumbers '\PHEN_ADP\bootstrap\Settings.sqf'";
	};
};

class Extended_PostInit_EventHandlers {
	class PHEN_ADP_PostInit {
		init = "call compile preprocessFileLineNumbers '\PHEN_ADP\bootstrap\XEH_postInit.sqf'";
	};
	class PHEN_ADP_PostInit_Debug {
		Init = "if (PHEN_ADP_enabled) then { call compile preprocessFileLineNumbers '\PHEN_ADP\bootstrap\Debug.sqf' }";
	}; //runs once start/restart + setting ON; has a manual start/restart on CBA changed addsetting code param tho
};
