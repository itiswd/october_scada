import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final client = MqttServerClient('100.120.50.109', 'flutter_scada');
  final String baseTopic = 'station1/#';
  bool connected = false;
  Map<String, bool> inputs = {};
  Map<String, double> holdingRegisters = {};

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
      debugPrint("❌ Connection error: $e");
      client.disconnect();
      // Retry initial connection after a short delay
      Future.delayed(const Duration(seconds: 5), () {
        if (!connected) {
          connect();
        }
      });
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(baseTopic, MqttQos.atMostOnce);
      client.updates?.listen(_onMessage);
    }
  }

  void _onConnected() {
    connected = true;
    notifyListeners();
    debugPrint('🟢 MQTT Connected');
  }

  void _onDisconnected() {
    connected = false;
    notifyListeners();
    debugPrint('🔴 MQTT Disconnected');
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
      debugPrint("❌ Error decoding message: $e | payload=$payload");
    }
  }

  void _processMessage(String topic, dynamic value) {
    final parts = topic.split('/');
    if (parts.length >= 3) {
      final category = parts[1];
      final key = parts[2];

      if (category == "inputs") {
        inputs[key] = value as bool;
      } else if (category == "holding_registers" || category == "holding_resgisters") {
        holdingRegisters[key] = (value is int)
            ? value.toDouble()
            : (value as num).toDouble();
      }
    }
  }

  void disconnect() {
    client.disconnect();
  }
}
