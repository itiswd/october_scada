import 'station_models.dart';

class StationRegistry {
  static final Map<int, StationConfig> _configs = {
    1: StationConfig(
      id: StationId(1),
      name: 'Station 1',
      subscribeTopics: const ['station1/#'],
    ),
    3: StationConfig(
      id: StationId(3),
      name: 'Station 3',
      subscribeTopics: const ['station3/#'],
    ),
    // Additional stations can be added here easily
  };

  static StationConfig? getByNumber(int stationNumber) => _configs[stationNumber];

  static List<StationConfig> all() => _configs.values.toList()
    ..sort((a, b) => a.id.value.compareTo(b.id.value));
}
