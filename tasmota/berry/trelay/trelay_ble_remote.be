# TRelay S3 BLE remote bridge
# - Applies initial FriendlyName/WebButton defaults once
# - Listens for BLE-related MQTT telemetry and maps remote actions to relays
# - Handles Smart Light inverted logic (Power3)

import mqtt
import string
import json

class TRelayBleRemote : Driver
  var _sub_topic
  var _cfg_key

  def init()
    self._sub_topic = "tele/#"
    self._cfg_key = "trelay_s3_cfg_v1"

    if !persist.find(self._cfg_key, 0)
      self.apply_defaults_once()
      persist[self._cfg_key] = 1
    end

    mqtt.subscribe(self._sub_topic, /topic, idx, data, databytes -> self.handle_tele(topic, data))
  end

  def stop()
    mqtt.unsubscribe(self._sub_topic)
  end

  def apply_defaults_once()
    # Friendly names
    tasmota.cmd("FriendlyName1 TRelay S3", true)
    tasmota.cmd("FriendlyName2 Power Socket", true)
    tasmota.cmd("FriendlyName3 White Light", true)
    tasmota.cmd("FriendlyName4 Smart Light", true)
    tasmota.cmd("FriendlyName5 Fan", true)
    tasmota.cmd("FriendlyName6 Inverter Socket", true)
    tasmota.cmd("FriendlyName7 green 💚 led", true)
    tasmota.cmd("FriendlyName8 red ♥️ led", true)

    # Web button labels
    tasmota.cmd("WebButton1 -", true)
    tasmota.cmd("WebButton2 ⚡🔌", true)
    tasmota.cmd("WebButton3 ⬜💡", true)
    tasmota.cmd("WebButton4 🟨💡", true)
    tasmota.cmd("WebButton5 𖣘 𖣘", true)
    tasmota.cmd("WebButton6 🔋🔌", true)
    tasmota.cmd("WebButton7 -", true)
    tasmota.cmd("WebButton8 -", true)

    # BLE bridge behavior for MI32 telemetry. This helps ensure button-like BLE
    # events are available over MQTT for this Berry listener.
    tasmota.cmd("Mi32Option2 1", true)
  end

  def handle_tele(full_topic, payload)
    var parts = string.split(full_topic, "/")
    if size(parts) < 3
      return true
    end

    var leaf = string.upper(parts[-1])
    if (leaf != "SENSOR") && (leaf != "BLE") && (leaf != "RESULT")
      return true
    end

    var doc = json.load(payload)
    if !doc
      return true
    end

    # Try multiple common BLE event forms.
    if doc.find("WizMote")
      var wz = doc["WizMote"]
      if wz && wz.find("Action")
        self.route_action(wz["Action"])
      end
    end

    if doc.find("MI32")
      self.route_from_object(doc["MI32"])
    end

    if doc.find("BLE")
      self.route_from_object(doc["BLE"])
    end

    # Some bridges publish directly at root
    self.route_from_object(doc)

    return true
  end

  def route_from_object(obj)
    if !obj
      return
    end

    if obj.find("Action")
      self.route_action(obj["Action"])
      return
    end

    if obj.find("action")
      self.route_action(obj["action"])
      return
    end

    if obj.find("Btn")
      self.route_button(obj["Btn"])
      return
    end

    if obj.find("Button")
      self.route_button(obj["Button"])
      return
    end

    if obj.find("button")
      self.route_button(obj["button"])
      return
    end
  end

  def route_action(action_raw)
    var action = string.lower(string.trim(str(action_raw)))

    # Generic actions
    if (action == "on") || (action == "off") || (action == "toggle")
      self.apply_power(2, action)
      return
    end

    # Common button/action aliases
    if (action == "single") || (action == "press") || (action == "click") || (action == "b1")
      self.apply_power(2, "toggle")
      return
    end
    if action == "b2"
      self.apply_power(3, "toggle")
      return
    end
    if action == "b3"
      self.apply_power(4, "toggle")
      return
    end
    if action == "b4"
      self.apply_power(5, "toggle")
      return
    end
    if action == "bu"
      self.apply_power(6, "toggle")
      return
    end
    if action == "bd"
      self.apply_power(7, "toggle")
      return
    end
  end

  def route_button(btn_raw)
    var btn = int(btn_raw)
    if btn <= 0
      return
    end

    # Button map -> Power channels
    # 1: Power Socket, 2: White Light, 3: Smart Light (inverted), 4: Fan,
    # 5: Inverter Socket, 6: Green LED, 7: Red LED
    if btn == 1
      self.apply_power(2, "toggle")
    elif btn == 2
      self.apply_power(3, "toggle")
    elif btn == 3
      self.apply_power(4, "toggle")
    elif btn == 4
      self.apply_power(5, "toggle")
    elif btn == 5
      self.apply_power(6, "toggle")
    elif btn == 6
      self.apply_power(7, "toggle")
    elif btn == 7
      self.apply_power(8, "toggle")
    end
  end

  def apply_power(channel, op)
    if channel < 1
      return
    end

    var states = tasmota.get_power()
    var i = channel - 1
    if i >= size(states)
      return
    end

    var current = states[i]
    var target = current

    if op == "on"
      target = true
    elif op == "off"
      target = false
    else
      target = !current
    end

    # Smart Light is on Power3 and is electrically inverted on this hardware.
    # Invert command intent so physical output matches the requested action.
    if channel == 3
      target = !target
    end

    tasmota.set_power(i, target)
  end
end
