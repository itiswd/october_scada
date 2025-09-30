import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:october_scada/domain/providers/mqtt_provider.dart';
import '../data/station_view.dart';

final stationViewProvider = Provider.family<StationView, int>((ref, station) {
  final mqtt = ref.watch(mqttProvider);
  return StationView(stationNumber: station, service: mqtt);
});
