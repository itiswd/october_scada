import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/mqtt_service.dart';

final mqttProvider = ChangeNotifierProvider<MqttService>((ref) {
  final service = MqttService(station: "station1");
  service.connect();
  return service;
});
