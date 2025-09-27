import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/responsive_helper.dart';
import '../../theme/app_theme.dart';

class StationPage extends StatelessWidget {
  final int stationNumber;

  const StationPage({super.key, required this.stationNumber});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Station Icon
                Container(
                  width: isMobile ? 120.w : 200.w,
                  height: isMobile ? 120.w : 200.w,
                  decoration: BoxDecoration(
                    color: AppTheme.darkerBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: isMobile ? 60.sp : 100.sp,
                    color: Colors.blue,
                  ),
                ),

                SizedBox(height: isMobile ? 32.h : 48.h),

                // Station Title
                Text(
                  'Station $stationNumber',
                  style: TextStyle(
                    fontSize: isMobile ? 32.sp : 48.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkerBackground,
                  ),
                ),

                SizedBox(height: isMobile ? 16.h : 24.h),

                // Status Text
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24.w : 32.w,
                    vertical: isMobile ? 12.h : 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: isMobile ? 16.sp : 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 24.h : 32.h),

                // Description
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 400.w,
                  ),
                  child: Text(
                    'This station is under development and will be available soon with full monitoring capabilities.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : 16.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
