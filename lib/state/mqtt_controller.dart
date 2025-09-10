import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/mqtt_service.dart';

final mqttProvider = ChangeNotifierProvider<MqttService>((ref) {
  final service = MqttService();
  service.connect(); // يبدأ الاتصال مع الـ broker
  return service;
});
