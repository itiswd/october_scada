import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/responsive_helper.dart';
import '../../../theme/app_theme.dart';

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
          Text(
            'Power Sources',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16.sp : 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),
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
            fontSize: isMobile ? 12.sp : 16.sp,
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
