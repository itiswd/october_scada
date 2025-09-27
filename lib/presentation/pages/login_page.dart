import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/responsive_helper.dart';
import '../../domain/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'otp_verification_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = ref.read(authProvider);
    final result = await authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      if (result.requiresOtp) {
        // الانتقال إلى صفحة التحقق من OTP
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationPage(email: _emailController.text.trim()),
          ),
        );
      }
    } else {
      // إظهار رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              children: [
                SizedBox(height: isMobile ? 60.h : 100.h),
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 40.h : 60.h),
                _buildLoginCard(isMobile),
                SizedBox(height: isMobile ? 30.h : 50.h),
                _buildUsersList(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Container(
          width: isMobile ? 80.w : 120.w,
          height: isMobile ? 80.w : 120.w,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.water_drop,
            size: isMobile ? 40.sp : 60.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 20.h : 30.h),
        Text(
          'October SCADA',
          style: TextStyle(
            fontSize: isMobile ? 28.sp : 36.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkerBackground,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Water Station Management System',
          style: TextStyle(
            fontSize: isMobile ? 14.sp : 18.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isMobile) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400.w),
      padding: EdgeInsets.all(isMobile ? 24.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 24.sp : 28.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkerBackground,
              ),
            ),
            SizedBox(height: isMobile ? 24.h : 32.h),
            _buildEmailField(),
            SizedBox(height: 16.h),
            _buildPasswordField(),
            SizedBox(height: isMobile ? 24.h : 32.h),
            _buildLoginButton(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال البريد الإلكتروني';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(bool isMobile) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 16.h : 20.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 3,
      ),
      child: _isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'تسجيل الدخول',
              style: TextStyle(
                fontSize: isMobile ? 16.sp : 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildUsersList(bool isMobile) {
    final authService = ref.read(authProvider);
    final users = authService.predefinedUsers;

    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400.w),
      padding: EdgeInsets.all(isMobile ? 16.w : 20.w),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔑 حسابات التجريب',
            style: TextStyle(
              fontSize: isMobile ? 16.sp : 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
          SizedBox(height: 12.h),
          ...users.map(
            (user) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${user.name}\n${user.email}',
                      style: TextStyle(
                        fontSize: isMobile ? 12.sp : 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Text(
                    user.password,
                    style: TextStyle(
                      fontSize: isMobile ? 12.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ملاحظة: سيتم إرسال رمز التحقق إلى بريدك الإلكتروني الفعلي',
            style: TextStyle(
              fontSize: isMobile ? 10.sp : 12.sp,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
