import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../core/utils/responsive_helper.dart';
import '../weather/weather_widget.dart';

class WeatherAndGaugesSection extends StatelessWidget {
  final double bar;
  final double ls;

  const WeatherAndGaugesSection({
    super.key,
    required this.bar,
    required this.ls,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      children: [
        // Weather Section
        const WeatherWidget(),
        SizedBox(height: 0.2.h),
        // Gauges Section
        _buildGaugesSection(isMobile),
      ],
    );
  }

  Widget _buildGaugesSection(bool isMobile) {
    return Container(
      height: isMobile ? 160.h : 300.h,
      padding: EdgeInsets.all(isMobile ? 12.w : 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: isMobile ? _buildMobileGauges() : _buildDesktopGauges(),
    );
  }

  Widget _buildMobileGauges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGaugeItem(ls, "L/S", _calculatePercent(ls, 100), true),
        _buildGaugeItem(bar, "BAR", _calculatePercent(bar, 10), true),
      ],
    );
  }

  Widget _buildDesktopGauges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGaugeItem(ls, "L/S", _calculatePercent(ls, 100), false),
        SizedBox(width: 56.w),
        _buildGaugeItem(bar, "BAR", _calculatePercent(bar, 10), false),
      ],
    );
  }

  double _calculatePercent(double value, double maxValue) {
    if (value == 0) return 0.0;
    final percent = (value / maxValue).clamp(0.0, 1.0);
    return percent < 0.1 ? 0.1 : percent; // Minimum 10% for visual feedback
  }

  Widget _buildGaugeItem(
    double value,
    String unit,
    double percent,
    bool isMobile,
  ) {
    final radius = isMobile ? 56.r : 88.r;
    final lineWidth = isMobile ? 10.w : 28.w;
    final avatarRadius = isMobile ? 48.r : 72.r;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(backgroundColor: Colors.grey[850], radius: avatarRadius),
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: percent,
          progressColor: Colors.blue,
          backgroundColor: Colors.grey.shade800,
          circularStrokeCap: CircularStrokeCap.butt,
          startAngle: 270,
          center: _buildGaugeCenter(value, unit, isMobile),
          animation: true,
          animationDuration: 1500,
        ),
      ],
    );
  }

  Widget _buildGaugeCenter(double value, String unit, bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            color: Colors.blue,
            fontSize: isMobile ? 18.sp : 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 10.sp : 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
