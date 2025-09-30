import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

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
  String overallStatus = "Stable";
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    previousLevels = List.from(widget.levels);
    overallStatus = _calculateOverallStatus();
    _startStatusTimer();
  }

  @override
  void didUpdateWidget(covariant StationTankCard3 oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          overallStatus = _calculateOverallStatus();
          previousLevels = List.from(widget.levels);
        });
      }
    });
  }

  String _calculateOverallStatus() {
    if (previousLevels.isEmpty) return "Stable";

    final currentLevel = widget.levels.first;
    final previousLevel = previousLevels.first;

    if (currentLevel > previousLevel) return "Filling";
    if (currentLevel < previousLevel) return "Draining";
    return "Stable"; // ✅ حالة واضحة بدل ما يفضل ماسك القديمة
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Filling":
        return Colors.green;
      case "Draining":
        return Colors.red;
      default:
        return Colors.grey; // ✅ Stable
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Filling":
        return Icons.arrow_upward;
      case "Draining":
        return Icons.arrow_downward;
      default:
        return Icons.pause; // ✅ Stable
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
          _buildHeader(statusColor, statusIcon, isMobile),
          SizedBox(height: isMobile ? 16.h : 20.h),
          _buildMetrics(isMobile),
          SizedBox(height: isMobile ? 24.h : 40.h),
          _buildTankBar(isMobile, statusColor),
        ],
      ),
    );
  }

  Widget _buildHeader(Color statusColor, IconData statusIcon, bool isMobile) {
    return Row(
      children: [
        CircleAvatar(
          radius: isMobile ? 12.r : 16.r,
          backgroundColor: statusColor.withAlpha(25),
          child: Icon(
            statusIcon,
            color: statusColor,
            size: isMobile ? 12.sp : 16.sp,
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
        Text(
          overallStatus,
          style: TextStyle(
            color: statusColor,
            fontSize: isMobile ? 16.sp : 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFlowWidget(isMobile),
        _buildLevelItem("Level", widget.levels.first, isMobile),
        _buildCapacityWidget(isMobile),
      ],
    );
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

  Widget _buildLevelItem(String label, double value, bool isMobile) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
        Text(
          "${value.toStringAsFixed(3)} M",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 14.sp : 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTankBar(bool isMobile, Color barColor) {
    final level = widget.levels.first;
    final percent = (level / widget.capacity).clamp(0.0, 1.0) * 100;
    final barHeight = isMobile ? 160.h : 320.h;
    final fillHeight = (level / widget.capacity).clamp(0.0, 1.0) * barHeight;

    return SizedBox(
      height: barHeight,
      width: double.infinity, // ياخد العرض كله
      child: Container(
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
                    color: level >= widget.capacity
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 10.sp : 16.sp,
                  ),
                ),
              ),
            ),
            _buildGridLines(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLines() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (_) => Divider(thickness: 0.5, color: Colors.white.withAlpha(75)),
      ),
    );
  }
}
