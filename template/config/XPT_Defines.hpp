// Config definitions
// Used to handle things such as default lobby param settings, and handle cases where new definitions are added, but old missions do not have them defined.
// TEMPLATE SPECIFIC DEFINITIONS. DO NOT EDIT THIS FILE DIRECTLY UNLESS YOU KNOW WHAT YOU'RE DOING!

//-------------------- Template parameter defines

// PVP setting
#ifndef XPT_TEXTCHANNELS_COOP
	#define XPT_TEXTCHANNELS_COOP disableChannels[] = {{0,false,true},{1,true,true},{2,true,true},{3,false,true},{4,true,true},{5,true,true}}
#endif
#ifndef XPT_TEXTCHANNELS_PVP
	#define XPT_TEXTCHANNELS_PVP disableChannels[] = {{0,false,true},{1,false,true},{2,true,true},{3,false,true},{4,true,true},{5,true,true}}
#endif

#ifndef XPT_DEFINEPVP
	XPT_isPVP = 0;
	XPT_TEXTCHANNELS_COOP;
#else
	XPT_isPVP = 1;
	XPT_TEXTCHANNELS_PVP;
#endif

// XPT map markers. Defaults to Enabled.
#ifndef XPT_MAPMARKERS
	#define XPT_MAPMARKERS 1
#endif

// XPT JIP teleporter. Defaults to Enabled.
#ifndef XPT_DEFINE_JIPTELEPORT
	#define XPT_DEFINE_JIPTELEPORT 1
#endif
XPT_jipteleport = XPT_DEFINE_JIPTELEPORT;

// XPT safe-start. Defaults to disabled.
#ifndef XPT_DEFINE_SAFESTART
	#define XPT_DEFINE_SAFESTART 0
#endif
XPT_safeStart = XPT_DEFINE_SAFESTART;

// XPT debug mode. Defaults to disabled.
#ifndef XPT_DEBUGMODE
	#define XPT_DEBUGMODE 0
#endif

// Custom loadouts. Defaults to disabled.
#ifndef XPT_DEFINE_CUSTOMLOADOUTS
	#define XPT_DEFINE_CUSTOMLOADOUTS 0
#endif
XPT_customLoadouts = XPT_DEFINE_CUSTOMLOADOUTS;

// Custom loadouts resolve function. Defaults to XPT_fnc_resolveInventory
#ifndef XPT_CUSTOMLOADOUTS_GETLOADOUTARRAY_FN
	#define XPT_CUSTOMLOADOUTS_GETLOADOUTARRAY_FN XPT_fnc_getLoadoutArray
#endif
XPT_customLoadouts_getLoadoutArrayFunction = XPT_CUSTOMLOADOUTS_GETLOADOUTARRAY_FN;

// Custom loadouts for zeus-spawned units. Defaults to disabled.
#ifndef XPT_DEFINE_CURATOR_CUSTOMLOADOUTS
	#define XPT_DEFINE_CURATOR_CUSTOMLOADOUTS 0
#endif
XPT_curator_customLoadouts = XPT_DEFINE_CURATOR_CUSTOMLOADOUTS;

// Remove NVGs from zeus-spawned units. Defaults to disabled.
#ifndef XPT_DEFINE_CURATOR_REMOVENVG
	#define XPT_DEFINE_CURATOR_REMOVENVG 0
#endif
XPT_curator_removeNVGs = XPT_DEFINE_CURATOR_REMOVENVG;

//-------------------- ACE 3 medical defines

// ACE 3 medical level. Defaults to basic medical.
#ifndef XPT_ACE3_MEDICALLEVEL
	#define XPT_ACE3_MEDICALLEVEL 0
#endif

// ACE 3 player damage threshold. Use server default.
#ifndef XPT_ACE3_PLAYERDAMAGETHRESHOLD
	#define XPT_ACE3_PLAYERDAMAGETHRESHOLD -1
#endif

// ACE 3 AI damage threshold. Use server default.
#ifndef XPT_ACE3_AIDAMAGETHRESHOLD
	#define XPT_ACE3_AIDAMAGETHRESHOLD -1
#endif

// ACE 3 Fatal Damage Source. Defaults to "Large hits to vitals only"
#ifndef XPT_ACE3_FATALDAMAGESOURCE
	#define XPT_ACE3_FATALDAMAGESOURCE 0
#endif

// ACE 3 PID for co-op missions. Defaults to "Only in Cardiac Arrest".
#ifndef XPT_ACE3_PLAYERFATAL_COOP
	#define XPT_ACE3_PLAYERFATAL_COOP 1
#endif

// ACE 3 Fatal Injuries for PVP. Defaults to "Always"
#ifndef XPT_ACE3_PLAYERFATAL_PVP
	#define XPT_ACE3_PLAYERFATAL_PVP 0
#endif

// ACE 3 cardiac arrest timer. Use server default.
#ifndef XPT_ACE3_CARDARREST_TIMER
	#define XPT_ACE3_CARDARREST_TIMER -1
#endif

//------------------- ACEX defines

// ACEX View restriction COOP. Defaults to off
#ifndef XPT_ACEX_VIEWRESTRICTION_COOP
	#define XPT_ACEX_VIEWRESTRICTION_COOP 0
#endif

// ACEX View restriction PVP. Defaults to first-person only
#ifndef XPT_ACEX_VIEWRESTRICTION_PVP
	#define XPT_ACEX_VIEWRESTRICTION_PVP 1
#endif

// ACEX View restriction (On foot). Defaults to off
#ifndef XPT_ACEX_VIEWRESTRICTION_FOOT
	#define XPT_ACEX_VIEWRESTRICTION_FOOT 0
#endif

// ACEX View restriction (Land vehicles). Defaults to off
#ifndef XPT_ACEX_VIEWRESTRICTION_LAND
	#define XPT_ACEX_VIEWRESTRICTION_LAND 0
#endif

// ACEX View restriction (Air vehicles). Defaults to off
#ifndef XPT_ACEX_VIEWRESTRICTION_AIR
	#define XPT_ACEX_VIEWRESTRICTION_AIR 0
#endif

// ACEX View restriction (Sea vehicles). Defaults to off
#ifndef XPT_ACEX_VIEWRESTRICTION_SEA
	#define XPT_ACEX_VIEWRESTRICTION_SEA 0
#endif