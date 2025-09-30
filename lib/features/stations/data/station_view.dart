import 'package:october_scada/data/services/mqtt_service.dart';

class StationView {
  final int stationNumber;
  final MqttService service;

  StationView({required this.stationNumber, required this.service});

  String get _prefix => 'station$stationNumber/';

  bool get isConnected => service.connected;

  bool input(String key) => service.inputs['$key'] ?? false;
  double reg(String key) => service.holdingRegisters['$key'] ?? 0.0;

  // Namespaced helpers for station3 patterns already used
  double tankDataValue(String key) => service.tankData['$key'] ?? 0.0;
  bool powerSource(String key) => service.powerSources['$key'] ?? false;
  double pressureSensor(String key) => service.pressureSensors['$key'] ?? 0.0;
  bool pumpStatus(String key) => service.pumpsStatus['$key'] ?? false;
}
