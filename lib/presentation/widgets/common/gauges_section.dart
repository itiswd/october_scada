import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GaugesSection extends StatelessWidget {
  final double bar;
  final double ls;
  final String? title;

  const GaugesSection({
    super.key,
    required this.bar,
    required this.ls,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return _buildGaugesSection(isMobile);
  }

  Widget _buildGaugesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 20.w),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10.w : 20.w,
                vertical: isMobile ? 4.h : 6.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withAlpha(25),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: isMobile ? 10.sp : 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12.h : 16.h),
          ],
          isMobile ? _buildMobileGauges() : _buildDesktopGauges(),
          if (title != null) SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildMobileGauges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildGaugeItem(ls, "L/S", _calculatePercent(ls, 600), true),
        _buildGaugeItem(bar, "BAR", _calculatePercent(bar, 10), true),
      ],
    );
  }

  Widget _buildDesktopGauges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildGaugeItem(ls, "L/S", _calculatePercent(ls, 600), false),
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
    final lineWidth = isMobile ? 12.w : 24.w;
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
          animation: false,
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
            fontSize: isMobile ? 18.sp : 20.sp,
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
