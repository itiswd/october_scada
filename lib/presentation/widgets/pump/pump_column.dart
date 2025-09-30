import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';

class PumpColumn extends StatelessWidget {
  final bool startOn;
  final bool startOff;
  final bool endOn;
  final bool endOff;
  final bool pump;

  const PumpColumn({
    super.key,
    required this.startOn,
    required this.startOff,
    required this.pump,
    required this.endOn,
    required this.endOff,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildValve(
          startOn,
          startOff,
          right: isMobile ? 6.5 : 8,
          isMobile: isMobile,
        ),
        PumpElement(isMobile: isMobile, pump: pump),
        _buildValve(
          endOn,
          endOff,
          left: isMobile ? 18 : 32,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildValve(
    bool isOn,
    bool isOff, {
    double right = 0,
    double left = 0,
    required bool isMobile,
  }) {
    String imagePath;
    if (isOn) {
      imagePath = AppConstants.valveOnImage;
    } else if (isOff) {
      imagePath = AppConstants.valveOffImage;
    } else {
      imagePath = AppConstants.valveNullImage;
    }

    return Padding(
      padding: EdgeInsets.only(right: right, left: left),
      child: Image.asset(
        imagePath,
        width: isMobile ? 40.w : 96.w,
        height: isMobile ? 40.w : 96.w,
      ),
    );
  }
}

class PumpElement extends StatelessWidget {
  final bool isMobile;
  final bool pump;
  const PumpElement({super.key, required this.pump, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      pump ? AppConstants.pumpOnImage : AppConstants.pumpOffImage,
      width: isMobile ? 54.w : 120.w,
      height: isMobile ? 54.w : 120.w,
    );
  }
}
