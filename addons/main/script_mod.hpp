#include "script_version.hpp"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCHLVL,BUILD

#define QUOTE(var1) #var1

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.00