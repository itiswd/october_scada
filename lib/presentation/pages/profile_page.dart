import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/responsive_helper.dart';
import '../../domain/providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.darkerBackground,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.darkerBackground.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              children: [
                SizedBox(height: isMobile ? 20.h : 40.h),
                _buildProfileCard(user, isMobile),
                SizedBox(height: isMobile ? 20.h : 40.h),
                _buildMenuItems(context, ref, isMobile),
                const Spacer(),
                _buildLogoutButton(context, ref, isMobile),
                SizedBox(height: isMobile ? 20.h : 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(user, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: isMobile ? 40.r : 60.r,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: isMobile ? 40.sp : 60.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 16.h : 24.h),
          Text(
            user?.name ?? 'مستخدم',
            style: TextStyle(
              fontSize: isMobile ? 20.sp : 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkerBackground,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: isMobile ? 14.sp : 16.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: isMobile ? 16.h : 20.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12.w : 16.w,
              vertical: isMobile ? 6.h : 8.h,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'متصل',
              style: TextStyle(
                fontSize: isMobile ? 12.sp : 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, WidgetRef ref, bool isMobile) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.settings,
          title: 'الإعدادات',
          onTap: () {
            // Navigate to settings page
          },
          isMobile: isMobile,
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          icon: Icons.help,
          title: 'المساعدة والدعم',
          onTap: () {
            // Navigate to help page
          },
          isMobile: isMobile,
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          icon: Icons.info,
          title: 'حول التطبيق',
          onTap: () {
            _showAboutDialog(context);
          },
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16.w : 20.w),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue, size: isMobile ? 20.sp : 24.sp),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16.sp : 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkerBackground,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: isMobile ? 16.sp : 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    WidgetRef ref,
    bool isMobile,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context, ref),
        icon: const Icon(Icons.logout),
        label: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontSize: isMobile ? 16.sp : 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 16.h : 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text('تأكيد تسجيل الخروج'),
          content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('October SCADA'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('نظام مراقبة وإدارة محطات المياه'),
              SizedBox(height: 8.h),
              const Text('الإصدار: 1.0.0'),
              SizedBox(height: 8.h),
              const Text('تطوير: فريق October Systems'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}
