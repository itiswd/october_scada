import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/responsive_helper.dart';
import '../../../theme/app_theme.dart';

class StationTankCard3 extends StatefulWidget {
  final String title;
  final double flow;
  final double capacity;
  final List<double> levels;

  const StationTankCard3({
    super.key,
    required this.title,
    required this.flow,
    required this.capacity,
    required this.levels,
  });

  @override
  State<StationTankCard3> createState() => _StationTankCardState();
}

class _StationTankCardState extends State<StationTankCard3> {
  List<double> previousLevels = [];
  List<String> barStatuses = [];
  String overallStatus = "Stable";
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    previousLevels = List.from(widget.levels);
    barStatuses = List.generate(widget.levels.length, (_) => "Stable");
    overallStatus = _calculateOverallStatus();
    _startStatusTimer();
  }

  @override
  void didUpdateWidget(covariant StationTankCard3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // حفظ المستويات السابقة للمقارنة
    if (oldWidget.levels != widget.levels) {
      previousLevels = oldWidget.levels;
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _startStatusTimer() {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _updateBarStatuses();
        final newOverallStatus = _calculateOverallStatus();

        setState(() {
          overallStatus = newOverallStatus;
        });

        // تحديث المستويات السابقة للمقارنة التالية
        previousLevels = List.from(widget.levels);
      }
    });
  }

  void _updateBarStatuses() {
    for (int i = 0; i < widget.levels.length; i++) {
      if (i < previousLevels.length) {
        final currentLevel = widget.levels[i];
        final previousLevel = previousLevels[i];

        if (currentLevel > previousLevel) {
          barStatuses[i] = "Filling";
        } else if (currentLevel < previousLevel) {
          barStatuses[i] = "Draining";
        } else {
          barStatuses[i] = "Stable";
        }
      }
    }
  }

  String _calculateOverallStatus() {
    if (previousLevels.isEmpty) return "Stable";

    final currentSum = widget.levels.fold(0.0, (a, b) => a + b);
    final previousSum = previousLevels.fold(0.0, (a, b) => a + b);

    if (currentSum > previousSum) return "Filling";
    if (currentSum < previousSum) return "Draining";
    return "Stable";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Filling":
        return Colors.green;
      case "Draining":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Filling":
        return Icons.arrow_upward;
      case "Draining":
        return Icons.arrow_downward;
      default:
        return Icons.pause;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(overallStatus);
    final statusIcon = _getStatusIcon(overallStatus);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.r : 24.r),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(overallStatus, statusColor, statusIcon, isMobile),
          SizedBox(height: isMobile ? 16.h : 20.h),
          _buildMetrics(isMobile),
          SizedBox(height: isMobile ? 24.h : 40.h),
          _buildLevelBars(isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(
    String status,
    Color statusColor,
    IconData statusIcon,
    bool isMobile,
  ) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: CircleAvatar(
            radius: isMobile ? 12.r : 16.r,
            backgroundColor: statusColor.withAlpha(25),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: isMobile ? 12.sp : 16.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16.sp : 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: statusColor,
            fontSize: isMobile ? 16.sp : 20.sp,
            fontWeight: FontWeight.bold,
          ),
          child: Text(status),
        ),
      ],
    );
  }

  Widget _buildMetrics(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFlowWidget(isMobile),
              _buildCapacityWidget(isMobile),
            ],
          ),
          SizedBox(height: 16.h),
          _buildLevelsGrid(isMobile),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFlowWidget(isMobile),
          _buildLevelsGrid(isMobile),
          _buildCapacityWidget(isMobile),
        ],
      );
    }
  }

  Widget _buildFlowWidget(bool isMobile) {
    return Column(
      children: [
        Text(
          "Flow",
          style: TextStyle(
            color: Colors.grey,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
        Text(
          "${widget.flow.toStringAsFixed(2)} L/S",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityWidget(bool isMobile) {
    return Column(
      children: [
        Text(
          "Capacity",
          style: TextStyle(
            color: Colors.grey,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
        Text(
          "${widget.capacity} M",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelsGrid(bool isMobile) {
    return _buildLevelItem("Level", widget.levels[0], isMobile);
  }

  Widget _buildLevelItem(String label, double value, bool isMobile) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: isMobile ? 12.sp : 20.sp,
          ),
        ),
        Text(
          "${value.toStringAsFixed(3)} M",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 12.sp : 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBars(bool isMobile) {
    return SizedBox(
      height: isMobile ? 200.h : 352.h,
      child: Stack(children: [_buildGridLines(), _buildBars(isMobile)]),
    );
  }

  Widget _buildGridLines() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (_) => Divider(thickness: 0.5, color: Colors.white.withAlpha(50)),
        ),
      ),
    );
  }

  Widget _buildBars(bool isMobile) {
    return Center(
      child: isMobile
          ? _buildMobileBars(isMobile)
          : _buildDesktopBars(isMobile),
    );
  }

  Widget _buildMobileBars(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.levels.asMap().entries.map((entry) {
        int index = entry.key;
        double level = entry.value;
        String barStatus = index < barStatuses.length
            ? barStatuses[index]
            : "Stable";
        Color barColor = _getStatusColor(barStatus);
        return _buildSingleBar(level, barColor, barStatus, isMobile, index);
      }).toList(),
    );
  }

  Widget _buildDesktopBars(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.levels.asMap().entries.map((entry) {
        int index = entry.key;
        double level = entry.value;
        String barStatus = index < barStatuses.length
            ? barStatuses[index]
            : "Stable";
        Color barColor = _getStatusColor(barStatus);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: _buildSingleBar(level, barColor, barStatus, isMobile, index),
        );
      }).toList(),
    );
  }

  Widget _buildSingleBar(
    double level,
    Color barColor,
    String barStatus,
    bool isMobile,
    int index,
  ) {
    final percent = (level / widget.capacity) * 100;
    final barWidth = isMobile ? 350.w : 1000.w;
    final barHeight = isMobile ? 160.h : 320.h;
    final fillHeight = (level / widget.capacity) * (isMobile ? 160.h : 320.h);

    return Column(
      children: [
        // البار نفسه
        Container(
          width: barWidth,
          height: barHeight,
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  height: fillHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: barColor,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [barColor.withAlpha(200), barColor],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    "${percent.toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: level == widget.capacity
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 10.sp : 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
