import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

import 'station1_page.dart';
import 'station3_page.dart';
import 'station_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Station1Page(), // Station 1 - المحطة الأساسية
      const StationPage(stationNumber: 2),
      const Station3Page(), // Station 3 - مع البيانات الكاملة
      const StationPage(stationNumber: 4),
      const StationPage(stationNumber: 5),
      const StationPage(stationNumber: 6),
      const StationPage(stationNumber: 7),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppTheme.darkerBackground,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: _buildBottomNavigationBar(isMobile),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isMobile) {
    return Container(
      color: AppTheme.darkerBackground,
      child: SafeArea(
        child: Container(
          height: isMobile ? 72.h : 104.h,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getHorizontalPadding(context),
            vertical: 8.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Station 1', isMobile),
              _buildNavItem(1, 'Station 2', isMobile),
              _buildNavItem(2, 'Station 3', isMobile),
              _buildNavItem(3, 'Station 4', isMobile),
              _buildNavItem(4, 'Station 5', isMobile),
              _buildNavItem(5, 'Station 6', isMobile),
              _buildNavItem(5, 'Station 7', isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, bool isMobile) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.blue : Colors.grey;
    final icon = isSelected ? Icons.water_drop : Icons.water_drop_outlined;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 4.w : 8.w,
            vertical: isMobile ? 8.h : 12.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: isMobile ? 20.sp : 32.sp),
              SizedBox(height: 2.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: isMobile ? 9.sp : 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
