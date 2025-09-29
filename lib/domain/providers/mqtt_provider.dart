import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/mqtt_service.dart';

final mqttProvider = ChangeNotifierProvider<MqttService>((ref) {
  final service = MqttService();
  service.connect();
  ref.onDispose(service.disconnect);
  return service;
});
