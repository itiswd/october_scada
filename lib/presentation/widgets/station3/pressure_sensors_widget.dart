import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

class PressureSensorsWidget extends StatelessWidget {
  final double sensor1;
  final double sensor2;

  const PressureSensorsWidget({
    super.key,
    required this.sensor1,
    required this.sensor2,
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
          Text(
            'Pressure Sensors',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16.sp : 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 16.h : 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPressureGauge('Sensor 1', sensor1, isMobile),
              _buildPressureGauge('Sensor 2', sensor2, isMobile),
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
