import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildValve(startOn, startOff, right: 8),
        _buildPump(),
        _buildValve(endOn, endOff, left: 32),
      ],
    );
  }

  Widget _buildValve(
    bool isOn,
    bool isOff, {
    double right = 0,
    double left = 0,
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
      child: Image.asset(imagePath, width: 96.w, height: 96.w),
    );
  }

  Widget _buildPump() {
    return Image.asset(
      pump ? AppConstants.pumpOnImage : AppConstants.pumpOffImage,
      width: 120.w,
      height: 120.w,
    );
  }
}
