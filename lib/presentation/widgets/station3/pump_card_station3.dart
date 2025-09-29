import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

class PumpCardStation3 extends StatelessWidget {
  final int pumpNumber;
  final bool isRunning;
  final bool isAuto;
  final bool isRemote;
  final int hours;
  final int minutes;
  final int seconds;

  const PumpCardStation3({
    super.key,
    required this.pumpNumber,
    required this.isRunning,
    required this.isAuto,
    required this.isRemote,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: isMobile ? 100.w : 160.w,
      padding: EdgeInsets.all(isMobile ? 8.r : 12.r),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isRunning ? Colors.green : Colors.red,
          width: 4.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pump number
          Text(
            'Pump $pumpNumber',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 12.sp : 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Pump image
          Image.asset(
            isRunning ? AppConstants.pumpOnImage : AppConstants.pumpOffImage,
            width: isMobile ? 48.w : 80.w,
            height: isMobile ? 48.w : 80.w,
          ),
          SizedBox(height: 8.h),

          // Status indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusBadge('A', isAuto, isMobile),
              SizedBox(width: 4.w),
              _buildStatusBadge('R', isRemote, isMobile),
            ],
          ),
          SizedBox(height: 8.h),

          // Runtime
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 6.w : 8.w,
              vertical: isMobile ? 4.h : 6.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.darkerBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 14.sp,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool isActive, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4.w : 6.w,
        vertical: isMobile ? 2.h : 3.h,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 8.sp : 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
