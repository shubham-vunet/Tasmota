# TRelay S3 BLE remote bootstrap
# Loaded automatically from filesystem at boot.

import trelay_ble_remote

if global.trelay_ble_remote_driver
  global.trelay_ble_remote_driver.stop()
end

global.trelay_ble_remote_driver = trelay_ble_remote.TRelayBleRemote()
