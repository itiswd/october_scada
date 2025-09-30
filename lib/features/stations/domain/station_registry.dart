import 'station_models.dart';

class StationRegistry {
  static final Map<int, StationConfig> _configs = {
    1: StationConfig(
      id: StationId(1),
      name: 'Station 1',
      subscribeTopics: const ['station1/#'],
    ),
    2: StationConfig(
      id: StationId(2),
      name: 'Station 2',
      subscribeTopics: const ['station2/#'],
    ),
    3: StationConfig(
      id: StationId(3),
      name: 'Station 3',
      subscribeTopics: const ['station3/#'],
    ),
    4: StationConfig(
      id: StationId(4),
      name: 'Station 4',
      subscribeTopics: const ['station4/#'],
    ),
    5: StationConfig(
      id: StationId(5),
      name: 'Station 5',
      subscribeTopics: const ['station5/#'],
    ),
    6: StationConfig(
      id: StationId(6),
      name: 'Station 6',
      subscribeTopics: const ['station6/#'],
    ),
    // Additional stations can be added here easily
  };

  static StationConfig? getByNumber(int stationNumber) => _configs[stationNumber];

  static List<StationConfig> all() => _configs.values.toList()
    ..sort((a, b) => a.id.value.compareTo(b.id.value));
}
