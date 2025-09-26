import 'package:flutter/material.dart';
import 'package:october_scada/core/utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }
}
