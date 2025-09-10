import 'package:flutter/material.dart';

class StationTankCard extends StatefulWidget {
  final String title;
  final double flow;
  final double capacity;
  final List<double> levels;

  const StationTankCard({
    super.key,
    required this.title,
    required this.flow,
    required this.capacity,
    required this.levels,
  });

  @override
  State<StationTankCard> createState() => _StationTankCardState();
}

class _StationTankCardState extends State<StationTankCard> {
  List<double> previousLevels = [];

  String _calculateStatus() {
    final currentSum = widget.levels.fold(0.0, (a, b) => a + b);
    final previousSum = previousLevels.fold(0.0, (a, b) => a + b);

    if (currentSum > previousSum) return "Filling";
    if (currentSum < previousSum) return "Draining";
    return "Stable";
  }

  @override
  void didUpdateWidget(covariant StationTankCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    previousLevels = oldWidget.levels; // حفظ القيم السابقة
  }

  @override
  Widget build(BuildContext context) {
    final status = _calculateStatus();

    // 🎨 لون الأعمدة حسب الحالة
    final Color barColor = status == "Filling"
        ? Colors.green
        : status == "Draining"
        ? Colors.orange
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1c1c1c),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: barColor.withAlpha(25),
                child: Icon(
                  status == "Filling"
                      ? Icons.arrow_upward
                      : status == "Draining"
                      ? Icons.arrow_downward
                      : Icons.pause,
                  color: barColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                  color: barColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // --- Flow + Levels + Capacity ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flow
              Column(
                children: [
                  const Text(
                    "Flow",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    "${widget.flow.toStringAsFixed(2)} L/S",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Levels
              Column(
                children: [
                  Row(
                    children: [
                      _buildLevel("Lv1", widget.levels[0]),
                      const SizedBox(width: 20),
                      _buildLevel("Lv2", widget.levels[1]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLevel("Lv3", widget.levels[2]),
                      const SizedBox(width: 20),
                      _buildLevel("Lv4", widget.levels[3]),
                    ],
                  ),
                ],
              ),

              // Capacity
              Column(
                children: [
                  const Text(
                    "Capacity",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    "${widget.capacity} M",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // --- Bars ---
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (_) => Divider(
                      thickness: 0.5,
                      color: Colors.white.withAlpha(50),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 48,
                  children: widget.levels.map((level) {
                    final percent = (level / widget.capacity) * 100;
                    return Container(
                      width: 130,
                      height: 200,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(15),
                        border: Border.all(color: Colors.grey.shade700),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: (level / widget.capacity) * 200,
                              width: double.infinity,
                              color: barColor, // 🎨 dynamic color
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "${percent.toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: level == widget.capacity
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevel(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          "${value.toStringAsFixed(2)} M",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
