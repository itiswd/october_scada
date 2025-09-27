import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/responsive_helper.dart';
import '../../../theme/app_theme.dart';

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

  @override
  void didUpdateWidget(covariant StationTankCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    previousLevels = oldWidget.levels;
  }

  String _calculateStatus() {
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
    final status = _calculateStatus();
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
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
          _buildHeader(status, statusColor, statusIcon, isMobile),
          SizedBox(height: isMobile ? 16.h : 20.h),
          _buildMetrics(isMobile),
          SizedBox(height: isMobile ? 24.h : 40.h),
          _buildLevelBars(statusColor, isMobile),
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
          status,
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
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLevelItem("Lv1", widget.levels[0], isMobile),
            SizedBox(width: isMobile ? 12.w : 20.w),
            _buildLevelItem("Lv2", widget.levels[1], isMobile),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLevelItem("Lv3", widget.levels[2], isMobile),
            SizedBox(width: isMobile ? 12.w : 20.w),
            _buildLevelItem("Lv4", widget.levels[3], isMobile),
          ],
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

  Widget _buildLevelBars(Color statusColor, bool isMobile) {
    return SizedBox(
      height: isMobile ? 200.h : 300.h,
      child: Stack(
        children: [_buildGridLines(), _buildBars(statusColor, isMobile)],
      ),
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

  Widget _buildBars(Color statusColor, bool isMobile) {
    return Center(
      child: isMobile
          ? _buildMobileBars(statusColor)
          : _buildDesktopBars(statusColor),
    );
  }

  Widget _buildMobileBars(Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.levels
          .map((level) => _buildSingleBar(level, statusColor, true))
          .toList(),
    );
  }

  Widget _buildDesktopBars(Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.levels.map((level) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: _buildSingleBar(level, statusColor, false),
        );
      }).toList(),
    );
  }

  Widget _buildSingleBar(double level, Color statusColor, bool isMobile) {
    final percent = (level / widget.capacity) * 100;
    final barWidth = isMobile ? 68.w : 180.w;
    final barHeight = isMobile ? 160.h : 280.h;
    final fillHeight = (level / widget.capacity) * (isMobile ? 160.h : 280.h);

    return Container(
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
            child: Container(
              height: fillHeight,
              width: double.infinity,
              color: statusColor,
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
    );
  }
}
