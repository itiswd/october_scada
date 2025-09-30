import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

class PowerSourcesStation3 extends StatelessWidget {
  final bool supply1;
  final bool supply2;
  final bool generator;

  const PowerSourcesStation3({
    super.key,
    required this.supply1,
    required this.supply2,
    required this.generator,
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
              'Power Sources',
              style: TextStyle(
                fontSize: isMobile ? 10.sp : 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 14.h : 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPowerSource(
                'Supply 1',
                supply1,
                'assets/images/transformer_on.png',
                'assets/images/transformer_off.png',
                isMobile,
              ),
              _buildPowerSource(
                'Supply 2',
                supply2,
                'assets/images/transformer_on.png',
                'assets/images/transformer_off.png',
                isMobile,
              ),
              _buildPowerSource(
                'Generator',
                generator,
                'assets/images/generator_on.png',
                'assets/images/generator_off.png',
                isMobile,
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),
        ],
      ),
    );
  }

  Widget _buildPowerSource(
    String title,
    bool isOn,
    String imageOn,
    String imageOff,
    bool isMobile,
  ) {
    return Column(
      children: [
        Image.asset(
          isOn ? imageOn : imageOff,
          width: isMobile ? 48.w : 80.w,
          height: isMobile ? 48.w : 80.w,
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 14.sp : 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          isOn ? 'ON' : 'OFF',
          style: TextStyle(
            fontSize: isMobile ? 12.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: isOn ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
