import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final client = MqttServerClient('100.120.50.109', 'flutter_scada');
  final String baseTopic = 'station1/#';
  bool connected = false;
  Map<String, bool> inputs = {};
  Map<String, double> holdingRegisters = {};
  // Additional data groups used across UI pages
  Map<String, bool> powerSources = {};
  Map<String, double> pressureSensors = {};
  Map<String, double> tankData = {};
  Map<String, bool> pumpsStatus = {};
  Map<String, int> pumpsTime = {};
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _subscription;
  bool _isSubscribed = false;

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
      _subscribeAndListen();
    }
  }

  void _onConnected() {
    connected = true;
    notifyListeners();
    debugPrint('🟢 MQTT Connected');
    _subscribeAndListen();
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
    _subscribeAndListen();
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );

    final topic = event[0].topic;
    dynamic value;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic> && decoded.containsKey('value')) {
        value = decoded['value'];
      } else {
        value = decoded;
      }
    } catch (_) {
      value = _coercePrimitive(payload);
    }

    _processMessage(topic, value);
    notifyListeners();
  }

  void _processMessage(String topic, dynamic value) {
    final parts = topic.split('/');
    if (parts.length >= 3) {
      final category = parts[1];
      final key = parts[2];

      if (category == "inputs") {
        inputs[key] = _toBool(value);
      } else if (category == "holding_registers" || category == "holding_resgisters") {
        holdingRegisters[key] = _toDouble(value);
      } else if (category == "power_sources") {
        powerSources[key] = _toBool(value);
      } else if (category == "pressure_sensors") {
        pressureSensors[key] = _toDouble(value);
      } else if (category == "pumps_status") {
        pumpsStatus[key] = _toBool(value);
      } else if (category == "pumps_time") {
        pumpsTime[key] = _toInt(value);
      } else if (category == "tank_data" || category == "tanks") {
        tankData[key] = _toDouble(value);
      }
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _isSubscribed = false;
    client.disconnect();
  }

  void _subscribeAndListen() {
    if (!_isSubscribed) {
      client.subscribe(baseTopic, MqttQos.atMostOnce);
      _subscription ??= client.updates?.listen(_onMessage);
      _isSubscribed = true;
    }
  }

  bool _toBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final t = v.trim().toLowerCase();
      if (t == 'true' || t == '1' || t == 'on') return true;
      if (t == 'false' || t == '0' || t == 'off') return false;
    }
    return false;
  }

  double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    if (v is String) {
      final parsed = double.tryParse(v.trim());
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final parsed = int.tryParse(v.trim());
      return parsed ?? 0;
    }
    return 0;
  }

  dynamic _coercePrimitive(String payload) {
    final t = payload.trim();
    final lower = t.toLowerCase();
    if (lower == 'true' || lower == 'false') {
      return lower == 'true';
    }
    final asNum = num.tryParse(t);
    if (asNum != null) return asNum;
    return t;
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
