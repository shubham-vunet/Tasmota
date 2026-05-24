#ifndef _USER_CONFIG_OVERRIDE_H_
#define _USER_CONFIG_OVERRIDE_H_

// Keep this build slim: explicitly disable Matter and KNX.
#undef USE_MATTER_DEVICE
#undef USE_KNX
#undef USE_KNX_WEB_MENU
#undef FIRMWARE_KNX_NO_EMULATION

#endif  // _USER_CONFIG_OVERRIDE_H_
