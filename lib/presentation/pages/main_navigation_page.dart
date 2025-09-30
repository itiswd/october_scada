import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/theme/theme.dart';

import 'station1_page.dart';
import 'station3_page.dart';
import 'station_page.dart';
import 'package:october_scada/features/stations/domain/station_registry.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;
  late final List<String> _labels;

  @override
  void initState() {
    super.initState();
    final configs = StationRegistry.all();
    _pages = configs.map((c) => _buildPageForStation(c.id.value)).toList();
    _labels = configs.map((c) => c.name).toList();
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
            children: List.generate(
              _labels.length,
              (i) => _buildNavItem(i, _labels[i], isMobile),
            ),
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

  Widget _buildPageForStation(int stationNumber) {
    switch (stationNumber) {
      case 1:
        return const Station1Page();
      case 3:
        return const Station3Page();
      case 4:
        // For Station 4 we can reuse Station 3 components pattern
        return const Station3Page();
      default:
        return StationPage(stationNumber: stationNumber);
    }
  }
}
