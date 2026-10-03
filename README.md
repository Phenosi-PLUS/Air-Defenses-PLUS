# Air Defenses PLUS
Base-game air defenses actually shoot down artillery, rockets, missiles and drones. Built to sit in a preset and cost nothing until something is in the air.

# for mod authors
Two ways to get your own air defense picked up, plus a fallback for when the config is not yours to touch. This assumes you already know how to make a mod. Nothing here needs a compat pbo or an init line.

## 1. Inherit a base-game emplacement
Anything inheriting `AAA_System_01_base_F`, `SAM_System_01_base_F`, `SAM_System_02_base_F`, `SAM_System_03_base_F` or `SAM_System_04_base_F` registers itself and gets the parent's config values, nothing to do on your side!

## 2. Declare the config block
Put this on your vehicle to declare your own values
```cpp
class CfgVehicles {
    class StaticMGWeapon;
    class MOD_MySAM_F: StaticMGWeapon {
        class PHEN_ADP {
            enabled = 1;
            mode = "missile";  // 'gun' or "missile"
            range = 6000;      // engagement radius in meters, the CBA range multiplier still applies on top
            needsAiming = 1;  // 1 when the launcher has to be aiming in the correct direction before it fires
            shotDelay = 3;        // seconds between shots
            fuzeRadius = 15;   // proximity/distance fuze radius in meters(M)
            icon = "\MyMod\data\ui\mySAM_icon_ca.paa";  // scroll action and ACE menu icon
        };
    };
};
```
Those are all seven config values, there are no others. `enabled = 0` opts a vehicle out, which is how you kill one variant that would otherwise inherit it.

### Tweaking exisiting config values
If your vehicle inherits from something that already has a `PHEN_ADP` block, the missing keys come from that block, normal config inheritance. 

If it does not, like the `StaticMGWeapon` example above, they get worked out from the main turret's weapon instead:
- **mode**, missile when the magazine's ammo is a `MissileCore`, gun otherwise
- **range**, `maxRange * 0.85` with a floor of 1500 for missiles, flat 2800 for guns
- **needsAiming**, true when the weapon's `minRange` is 500 or higher
- **shotDelay**, 2
- **fuzeRadius**, 12

### icon
The only cosmetic key and you almost never need it. Leave it out and the scroll action uses the vehicle's own `icon` from CfgVehicles, so the emplacement shows its map silhouette. A `CfgVehicleIcons` shorthand like `iconStaticAA` works as well as a full path.

### General Explainer on 'guiding' projectiles
The 'intercepting' projectile gets given its target with `setMissileTarget` and the base-game engine mechanics fly it from there. This is the main method and the best one to use, HOWEVER when you ACE3 _(they enforce their missileguidance PBO with their own PfH)_ or ya got unguided munitions this breaks/won't ever work.

The scripted path is the fallback for when the base-game method is not accesiable (see reason above!), but also applies to ammo with `maneuvrability = 0` that can't not steer/manouver at all. Additionaly there is a fail `cond` when the lock does not stick three 'ticks' in a row the round gets flown by script instead, going to the target and accelerating up to its own `maxSpeed` from CfgAmmo.

Some stuff you can't set (bc you don't need to!), but good to know about. Fixed/hard-coded values for every interceptor:
- **3 seconds** arming time before a miss can be called against it
- **120m** past its closest approach counts as a miss, then it self destructs
- **45 seconds** flight time cap, then it self destructs
- **120 deg/s** turn rate, scripted path only

So the only missile number that is actually yours is `fuzeRadius`, how close the interceptor has to
get to count as a hit.

One more ACE3 note while we are at it..: `ace_missileguidance_enabled` drops to 1 for half a second around
every interceptor shot, because ACE grabs any AI fired round onto its own IR seeker and that seeker
cannot see the invisible proxy the whole thing aims at (there might be a better way but I have yet to find it..?)

### Gun mode
Guns never get 'forced' to fire. The AI gunner does the shooting part and the mod only makes 'em aim at a
hidden proxy attached to the shell, so a gun emplacement needs a crew the AI can use. The base-game
statics have `isUav = 1` already so they always work out of the box (unless you spawn them with zeus crew box unticked ofc!).

Intercept timing comes off the magazine's `initSpeed` (900 when it has none), so give your magazine
a valid `initSpeed` or the intercept will look wack.

## 3. Neither of the above
If the turret emplacement does not inherit a base-game class and you cannot touch its config, the classname
goes in the CBA setting **Extra Air Defense Classnames**. It is a text box holding an array literally,
so keep the brackets and the quotes:

```sqf
["MOD_SomeAAA_F","MOD_SomeSAM_F"]
```

The check is `isKindOf`, so a parent classname covers everything under it. Registration runs once at postInit, so this one needs a mission restart. What it gets is the gotten from the setup in section 2, and only `mode`, `range` and `needsAiming` read anything off the weapon; the other two are the flat defaults.
## Will it shoot my custom ammo down
Threats are sorted by what the ammo inherits from (again; only checked once at game start!).
A shell made off a base-game core is picked up with nothing declared on your side:
- **MissileCore**, cruise and AT missiles
- **SubmunitionCore**, MLRS bomblets
- **ShellCore**, artillery and mortar
- **RocketCore**, rocket artillery and RPGs

Anything inheriting `BulletCore`, `GrenadeCore`, `TimeBombCore`, `LaserBombCore`, `ShotDeployCore`,
`FlareCore` or `SmokeShellCore` is ignored ALWAYS.

A round also has to be going UP. `artilleryLock = 1` is what I check for that. it is on every base-game shell, bomblet and artillery rocket. ALSO again it is inherited, so mods building off those get it
automatically.

Drones come in through a separate class EH (eventhandler) on `Air` and need `unitIsUAV` true, so a scripted-AI aircraft that is not a real UAV is not a drone as far as this is able to detect it.

## Changing an turrets's state from a mission script
`PHEN_ADP_setState` only runs server side, so send it with `CBA_fnc_serverEvent`. It takes those two
values and IGNORES all else related stuff.

```sqf
// 0 off, 1 random, 2 closest threat, 3 highest threat
["PHEN_ADP_setState", [_turret, "PHEN_ADP_mode", 3]] call CBA_fnc_serverEvent;
["PHEN_ADP_setState", [_turret, "PHEN_ADP_alarm", false]] call CBA_fnc_serverEvent;
```

Both get broadcast global, so returning their values back works on any machine:
```sqf
private _mode = _turret getVariable ["PHEN_ADP_mode", 0];
```

## Known limits
- One emplacement takes one target at a time, and it is busy until that shot resolves or it loses
  the target. There is no salvo (ATM this works best might chance).
- Two emplacements will not both target the same threat, that is on purpose! _(Conserving Ammo is better imo given you dont have player or AI logi restocking AAA/SAM sites like ever)_
- All of it runs on the server. There is no local path, a client changing a mode goes through the
  event like everything else.

If something is not working, turn the debug setting on first! It puts an INCOMING or FRIENDLY marker on every round the mod classifies as a threat, on its own, whether or not an turret ever registered. No marker means the ammo side is the problem; a marker with an emplacement that does not react means the registration is. Either way I would like to hear about it :))
