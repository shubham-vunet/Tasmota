#ifndef _USER_CONFIG_OVERRIDE_H_
#define _USER_CONFIG_OVERRIDE_H_

// Keep this build slim: explicitly disable features not needed for this device.
#undef USE_MATTER_DEVICE
#undef USE_KNX
#undef USE_KNX_WEB_MENU
#undef FIRMWARE_KNX_NO_EMULATION
#undef USE_DOMOTICZ
#undef USE_TIMERS
#undef USE_TIMERS_WEB

// Device default name (FriendlyName1). Remaining FriendlyName/WebButton labels
// are applied by Berry on first boot from autoexec.be.
#undef FRIENDLY_NAME
#define FRIENDLY_NAME          "TRelay S3"

#endif  // _USER_CONFIG_OVERRIDE_H_
