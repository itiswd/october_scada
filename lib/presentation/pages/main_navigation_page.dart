import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/responsive_helper.dart';
import '../../domain/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
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
      const DashboardPage(), // Station 1 - المحطة الأساسية
      const StationPage(stationNumber: 2),
      const StationPage(stationNumber: 3),
      const StationPage(stationNumber: 4),
      const ProfilePage(), // صفحة الملف الشخصي
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: _currentIndex == 0 ? _buildAppBar(currentUser, isMobile) : null,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(isMobile),
    );
  }

  PreferredSizeWidget _buildAppBar(user, bool isMobile) {
    return AppBar(
      backgroundColor: AppTheme.darkerBackground,
      elevation: 0,
      title: Text(
        'October SCADA',
        style: TextStyle(
          fontSize: isMobile ? 20.sp : 24.sp,
          fontWeight: FontWeight.bold,
          color: AppTheme.darkerBackground,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(left: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user?.name ?? 'مستخدم',
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkerBackground,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'متصل',
                      style: TextStyle(
                        fontSize: isMobile ? 10.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 4),
                child: CircleAvatar(
                  radius: isMobile ? 18.r : 20.r,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isMobile ? 18.sp : 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
              _buildNavItem(4, 'الملف الشخصي', Icons.person, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, bool isMobile) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.blue : Colors.grey;

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
