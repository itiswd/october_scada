class StationId {
  final int value;
  const StationId(this.value);

  @override
  String toString() => 'station${value}';
}

class StationConfig {
  final StationId id;
  final String name;
  final List<String> subscribeTopics;

  const StationConfig({
    required this.id,
    required this.name,
    required this.subscribeTopics,
  });
}
