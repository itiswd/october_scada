import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint.w;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint.w &&
        width < AppConstants.desktopBreakpoint.w;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        AppConstants.desktopBreakpoint.w;
  }

  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 12.w;
    if (isTablet(context)) return 24.w;
    return 32.w;
  }

  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) return 16.h;
    if (isTablet(context)) return 20.h;
    return 24.h;
  }
}
