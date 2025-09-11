import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    // 🎨 dynamic bar color
    final Color barColor = status == "Filling"
        ? Colors.green
        : status == "Draining"
        ? Colors.red
        : Colors.grey;

    return Container(
      padding: EdgeInsets.all(24.0.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1c1c1c),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: barColor.withAlpha(25),
                child: Icon(
                  status == "Filling"
                      ? Icons.arrow_upward
                      : status == "Draining"
                      ? Icons.arrow_downward
                      : Icons.pause,
                  color: barColor,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                  color: barColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // --- Flow + Levels + Capacity ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flow
              Column(
                children: [
                  Text(
                    "Flow",
                    style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                  ),
                  Text(
                    "${widget.flow.toStringAsFixed(2)} L/S",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
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
                      SizedBox(width: 20.w),
                      _buildLevel("Lv2", widget.levels[1]),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildLevel("Lv3", widget.levels[2]),
                      SizedBox(width: 20.w),
                      _buildLevel("Lv4", widget.levels[3]),
                    ],
                  ),
                ],
              ),

              // Capacity
              Column(
                children: [
                  Text(
                    "Capacity",
                    style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                  ),
                  Text(
                    "${widget.capacity} M",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 40.h),

          // --- Bars ---
          SizedBox(
            height: 300.h,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (_) => Divider(
                        thickness: 0.5,
                        color: Colors.white.withAlpha(50),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.levels.map((level) {
                      final percent = (level / widget.capacity) * 100;
                      return Container(
                        width: 180.w,
                        height: 280.h,
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          border: Border.all(color: Colors.grey.shade700),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: (level / widget.capacity) * 200.h,
                                width: double.infinity,
                                color: barColor,
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
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
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
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 20.sp),
        ),
        Text(
          "${value.toStringAsFixed(3)} M",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }
}
