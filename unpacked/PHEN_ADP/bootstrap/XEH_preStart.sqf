//preStart
_declared = ("isClass (_x >> 'PHEN_ADP')" configClasses (configFile >> "CfgVehicles"));
_roots = _declared select { !(isClass ((inheritsFrom _x) >> "PHEN_ADP")) };

uiNamespace setVariable ["PHEN_ADP_configClasses", _roots apply { configName _x }];

//MLRS weapons are actualy RocketPods, mortars, howitzers, etc is CannonCore, gotta split em here
_ammoRoot = (configFile >> "CfgAmmo");
_queue = [];
{
    _weaponMags = (getArray (_x >> "magazines"));
    {
        _cfgWelll = (configFile >> "CfgMagazineWells" >> _x);
        { _weaponMags append (getArray _x) } forEach (configProperties [_cfgWelll, "(isArray _x)"]);
    } forEach (getArray (_x >> "magazineWell"));
    { _queue pushBackUnique (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) } forEach _weaponMags;
} forEach ("((configName _x) isKindOf ['RocketPods', (configFile >> 'CfgWeapons')])" configClasses (configFile >> "CfgWeapons"));

_rocketArty = [];
while { (_queue isNotEqualTo []) } do {
    _ammo = (_queue deleteAt 0);
    _isArty = ((_ammo isKindOf ["ShellCore", _ammoRoot]) || { (_ammo isKindOf ["SubmunitionCore", _ammoRoot]) });
    if ((_isArty) && { !(_ammo in _rocketArty) }) then {
        _rocketArty pushBack _ammo;
        _nextStage = (_ammoRoot >> _ammo >> "submunitionAmmo");
        if (isText _nextStage) then { _queue pushBack (getText _nextStage) };
    };
};
uiNamespace setVariable ["PHEN_ADP_rocketArtyAmmo", _rocketArty];
