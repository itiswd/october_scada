// ======================
// Unified MQTT Service
// ======================
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final client = MqttServerClient('100.120.50.109', 'flutter_scada');
  final String station; // station1 أو station3
  bool connected = false;

  // Station1 data
  Map<String, bool> inputs = {};
  Map<String, double> holdingRegisters = {};

  // Station3 data
  Map<String, bool> powerSources = {};
  Map<String, double> pressureSensors = {};
  Map<String, bool> pumpsStatus = {};
  Map<String, int> pumpsTime = {};
  Map<String, double> tankData = {};

  MqttService({required this.station});

  Future<void> connect() async {
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.autoReconnect = true;

    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onAutoReconnect = _onAutoReconnect;
    client.onAutoReconnected = _onAutoReconnected;

    try {
      await client.connect();
    } catch (e) {
      debugPrint("❌ $station Connection error: $e");
      client.disconnect();
      // Retry initial connection after a short delay
      Future.delayed(const Duration(seconds: 5), () {
        if (!connected) {
          connect();
        }
      });
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('$station/#', MqttQos.atMostOnce);
      client.updates?.listen(_onMessage);
    }
  }

  void _onConnected() {
    connected = true;
    notifyListeners();
    debugPrint('🟢 MQTT $station Connected');
  }

  void _onDisconnected() {
    connected = false;
    notifyListeners();
    debugPrint('🔴 MQTT $station Disconnected');
  }

  void _onAutoReconnect() {
    debugPrint('🔄 MQTT Auto reconnecting...');
  }

  void _onAutoReconnected() {
    debugPrint('✅ MQTT Auto reconnected');
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );

    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final topic = event[0].topic;
      final value = decoded['value'];

      _processMessage(topic, value);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error decoding $station message: $e | payload=$payload");
    }
  }

  void _processMessage(String topic, dynamic value) {
    final parts = topic.split('/');
    if (parts.length >= 3) {
      final category = parts[1];
      final key = parts[2];

<<<<<<< HEAD
      if (station == "station1") {
        if (category == "inputs") {
          inputs[key] = value as bool;
        } else if (category == "holding_resgisters") {
          holdingRegisters[key] = (value is int)
              ? value.toDouble()
              : (value as num).toDouble();
        }
      } else if (station == "station3") {
        switch (category) {
          case "power":
            powerSources[key] = value as bool;
            break;
          case "pressure_sensors":
            pressureSensors[key] = (value is int)
                ? value.toDouble()
                : (value as num).toDouble();
            break;
          case "pumps_status":
            if (key.contains('_flow') || key.contains('_level')) {
              tankData[key] = (value is int)
                  ? value.toDouble()
                  : (value as num).toDouble();
            } else {
              pumpsStatus[key] = value as bool;
            }
            break;
          case "pumps_time":
            pumpsTime[key] = value as int;
            break;
        }
=======
      if (category == "inputs") {
        inputs[key] = value as bool;
      } else if (category == "holding_registers" || category == "holding_resgisters") {
        holdingRegisters[key] = (value is int)
            ? value.toDouble()
            : (value as num).toDouble();
>>>>>>> 8982c0ae1770e125c01d02422f64aa458af45015
      }
    }
  }

  void disconnect() {
    client.disconnect();
  }
}
