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
#undef USE_GPIO_VIEWER
#undef USE_INFLUXDB
#undef USE_SDCARD
#undef USE_ETHERNET
#undef USE_EQ3_ESP32
#undef USE_MI_ESP32
#undef USE_IR_REMOTE
#undef USE_IR_RECEIVE
#undef USE_SCRIPT
#undef USE_EMULATION
#undef USE_EMULATION_HUE
#undef USE_EMULATION_WEMO
#undef USE_AUTOCONF
#undef USE_EXTENSION_MANAGER
#undef USE_SYSLOG
#undef USE_DISPLAY
#undef USE_UFILESYS
#undef USE_DEBUG_DRIVER

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

// Load external CSS for Tasmota web UI.
#define EXTERNAL_WEB_CSS_URL   "https://assets.cossth.com/tasmota/styles.css"
// Load external JavaScript for Tasmota web UI.
#define EXTERNAL_WEB_JS_URL    "https://assets.cossth.com/tasmota/script.js"

// Custom firmware author text shown in the web footer.
#define FIRMWARE_AUTHOR_LABEL  "Shubham Sharma"

#endif  // _USER_CONFIG_OVERRIDE_H_
