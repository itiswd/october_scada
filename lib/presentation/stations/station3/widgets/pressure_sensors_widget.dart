import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PressureAndFlowSensorsWidget extends StatelessWidget {
  final double pressure;
  final double flow;

  const PressureAndFlowSensorsWidget({
    super.key,
    required this.pressure,
    required this.flow,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16.r : 20.r),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              'Pressure and Flow',
              style: TextStyle(
                fontSize: isMobile ? 10.sp : 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPressureGauge('Sensor 1', pressure, isMobile),
              _buildPressureGauge('Sensor 2', flow, isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPressureGauge(String label, double value, bool isMobile) {
    final radius = isMobile ? 56.r : 88.r;
    final lineWidth = isMobile ? 12.w : 20.w;
    final avatarRadius = isMobile ? 48.r : 72.r;
    final percent = (value / 10.0).clamp(0.0, 1.0);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[850],
              radius: avatarRadius,
            ),
            CircularPercentIndicator(
              radius: radius,
              lineWidth: lineWidth,
              percent: percent,
              progressColor: _getPressureColor(value),
              backgroundColor: Colors.grey.shade800,
              circularStrokeCap: CircularStrokeCap.butt,
              startAngle: 270,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(
                      color: _getPressureColor(value),
                      fontSize: isMobile ? 16.sp : 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'BAR',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 10.sp : 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              animation: false,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 12.sp : 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getPressureColor(double pressure) {
    if (pressure < 3.0) return Colors.red;
    if (pressure < 5.0) return Colors.orange;
    if (pressure < 7.0) return Colors.yellow;
    return Colors.green;
  }
}
