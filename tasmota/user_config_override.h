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

#if defined(ESP32) && defined(CONFIG_IDF_TARGET_ESP32S3)
// TRelay S3 uses a 74HC595 for all relay/LED outputs.
#define USE_SHIFT595
#undef SHIFT595_DEVICE_COUNT
#define SHIFT595_DEVICE_COUNT 1
// Smart Light is wired inverted (FriendlyName4 / POWER4).
#define SHIFT595_INVERT_POWER_MASK 0x00000008

// Force the custom module so the required GPIO assignments are present on boot.
#undef MODULE
#define MODULE TRELAY_S3
#undef FALLBACK_MODULE
#define FALLBACK_MODULE TRELAY_S3
#endif

// Device default name (FriendlyName1). Remaining FriendlyName/WebButton labels
// are applied by Berry on first boot from autoexec.be.
#undef FRIENDLY_NAME
#define FRIENDLY_NAME          "TRelay S3"

// Preserve old static MQTT behavior with updated broker host.
#undef MQTT_HOST
#define MQTT_HOST              "10.10.2.3"

#endif  // _USER_CONFIG_OVERRIDE_H_
