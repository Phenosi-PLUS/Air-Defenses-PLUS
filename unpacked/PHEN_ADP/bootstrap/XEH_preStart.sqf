//preStart
_declared = ("isClass (_x >> 'PHEN_ADP')" configClasses (configFile >> "CfgVehicles"));
_roots = _declared select { !(isClass ((inheritsFrom _x) >> "PHEN_ADP")) };

uiNamespace setVariable ["PHEN_ADP_configClasses", _roots apply { configName _x }];
