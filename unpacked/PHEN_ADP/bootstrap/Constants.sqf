// Constant Variables
// preInit pre-definedvars in easy to find place / constants 
//(IK very GDscript coated of me xd) and the two needed caches for performance sys.


PHEN_ADP_AMMO_BLACKLIST = [
    "PHEN_ADP_InterceptBurst",
    "BulletCore",
    "GrenadeCore",
    "TimeBombCore",
    "LaserBombCore",
    "ShotDeployCore",
    "FlareCore",
    "SmokeShellCore"
];

//base classes the register EHs go off of, subclasses inherit
PHEN_ADP_BASE_CLASSES = [
    "AAA_System_01_base_F",
    "SAM_System_01_base_F",
    "SAM_System_02_base_F",
    "SAM_System_03_base_F",
    "SAM_System_04_base_F"
];

PHEN_ADP_MODE_NAMES = [
    localize "STR_PHEN_ADP_Mode_Off",
    localize "STR_PHEN_ADP_Mode_Random",
    localize "STR_PHEN_ADP_Mode_Closest",
    localize "STR_PHEN_ADP_Mode_Highest"
];

PHEN_ADP_PROXY_BY_SIDE = [
    [east, "PHEN_ADP_TargetProxy_O"],
    [west, "PHEN_ADP_TargetProxy_B"],
    [resistance,  "PHEN_ADP_TargetProxy_I"]
];
PHEN_ADP_PROXY_FALLBACK = "PHEN_ADP_TargetProxy_O";

PHEN_ADP_SPEAKER_CLASSES = ["Land_Loudspeakers_F", "Land_PortableSpeakers_01_F"]; //loudspeakers the alarm goes to first
PHEN_ADP_ALARM_LENGTH = 8;

//one random picked per intercept just so a burst doesnt have the same boring effect.
//all based on PHEN_ADP_InterceptBurst, so the one blacklist classname entry catches all
PHEN_ADP_BURST_CLASSES = [
    "PHEN_ADP_InterceptBurst",
    "PHEN_ADP_InterceptBurst_Heli",
    "PHEN_ADP_InterceptBurst_AA"
];

PHEN_ADP_COLOR_TITLE = "#6FBCDC";
PHEN_ADP_COLOR_ON = "#7DD49F";
PHEN_ADP_COLOR_OFF = "#E87C5E";
//fallback icon
PHEN_ADP_ICON        = "\A3\ui_f\data\IGUI\Cfg\Targeting\SeekerLocked_ca.paa";
PHEN_ADP_ACTION_DISTANCE = 10;

//DEBUG stuff
PHEN_ADP_DEBUG_ICON = "\A3\ui_f\data\IGUI\Cfg\Targeting\SeekerLocked_ca.paa";
PHEN_ADP_DEBUG_COLOR = [1, 0.35, 0.2, 1];
PHEN_ADP_DEBUG_COLOR_FRIENDLY = [0.3, 0.6, 1, 1];

//classifier caches, one entry per classname, ONCE per like 'mission'/server session
PHEN_ADP_ammoCache = createHashMap;
PHEN_ADP_arcCache = createHashMap;
//one shared proxy group per side; keyed by str side. see PHEN_ADP_fnc_getProxyGroup aswell
PHEN_ADP_proxyGroups = createHashMap;
PHEN_ADP_configSetupCache = createHashMap;

//server side state tracking
PHEN_ADP_extraClassList = [];
PHEN_ADP_batteries = [];
PHEN_ADP_threats = [];
PHEN_ADP_trackerHandle = -1;
PHEN_ADP_projectileEH = -1;

//[posASL, Expiration] per siren currently howling, pruned on every alarm request
PHEN_ADP_alarmsSounding = [];
