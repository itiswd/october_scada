import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/responsive_helper.dart';
import '../../theme/app_theme.dart';
import 'dashboard_page.dart';
import 'station_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // Station 1 - المحطة الأساسية
    const StationPage(stationNumber: 2),
    const StationPage(stationNumber: 3),
    const StationPage(stationNumber: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(isMobile),
    );
  }

  Widget _buildBottomNavigationBar(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
              _buildNavItem(0, 'Station 1', Icons.water_drop, isMobile),
              _buildNavItem(
                1,
                'Station 2',
                Icons.water_drop_outlined,
                isMobile,
              ),
              _buildNavItem(
                2,
                'Station 3',
                Icons.water_drop_outlined,
                isMobile,
              ),
              _buildNavItem(
                3,
                'Station 4',
                Icons.water_drop_outlined,
                isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, bool isMobile) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.blue : Colors.grey;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12.w : 16.w,
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
              style: TextStyle(
                color: color,
                fontSize: isMobile ? 10.sp : 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
