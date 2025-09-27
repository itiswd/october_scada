import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/presentation/pages/main_navigation_page.dart';

import '../../core/utils/responsive_helper.dart';
import '../../domain/providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // التحقق التلقائي عند إدخال 6 أرقام
    if (_getOtp().length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      _showSnackBar('يرجى إدخال رمز التحقق كاملاً', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    final authService = ref.read(authProvider);
    final result = await authService.verifyOtp(widget.email, otp);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      _showSnackBar(result.message, Colors.green);
      // العودة إلى الصفحة الرئيسية أو إغلاق صفحة تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationPage()),
      ); // للعودة من صفحة تسجيل الدخول أيضاً
    } else {
      _showSnackBar(result.message, Colors.red);
      _clearOtp();
    }
  }

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;

    setState(() => _isResending = true);

    final authService = ref.read(authProvider);
    final result = await authService.resendOtp(widget.email);

    setState(() => _isResending = false);

    if (!mounted) return;

    if (result.success) {
      _showSnackBar('تم إعادة إرسال رمز التحقق', Colors.green);
      _startResendTimer();
      _clearOtp();
    } else {
      _showSnackBar(result.message, Colors.red);
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                SizedBox(height: isMobile ? 40.h : 60.h),
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 40.h : 60.h),
                _buildOtpCard(isMobile),
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
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(30),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.security,
            size: isMobile ? 40.sp : 60.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 20.h : 30.h),
        Text(
          'التحقق من الهوية',
          style: TextStyle(
            fontSize: isMobile ? 24.sp : 32.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkerBackground,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'تم إرسال رمز التحقق إلى',
          style: TextStyle(
            fontSize: isMobile ? 14.sp : 16.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.email,
          style: TextStyle(
            fontSize: isMobile ? 16.sp : 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpCard(bool isMobile) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400.w),
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
          Text(
            'ادخل رمز التحقق',
            style: TextStyle(
              fontSize: isMobile ? 18.sp : 22.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkerBackground,
            ),
          ),
          SizedBox(height: isMobile ? 24.h : 32.h),
          _buildOtpInputFields(isMobile),
          SizedBox(height: isMobile ? 24.h : 32.h),
          _buildVerifyButton(isMobile),
          SizedBox(height: 16.h),
          _buildResendSection(isMobile),
        ],
      ),
    );
  }

  Widget _buildOtpInputFields(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: isMobile ? 40.w : 50.w,
          height: isMobile ? 50.h : 60.h,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: isMobile ? 20.sp : 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkerBackground,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton(bool isMobile) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
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
                'تأكيد',
                style: TextStyle(
                  fontSize: isMobile ? 16.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildResendSection(bool isMobile) {
    return Column(
      children: [
        Text(
          'لم تستلم الرمز؟',
          style: TextStyle(
            fontSize: isMobile ? 14.sp : 16.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        if (_resendTimer > 0)
          Text(
            'يمكنك إعادة الإرسال خلال $_resendTimer ثانية',
            style: TextStyle(
              fontSize: isMobile ? 12.sp : 14.sp,
              color: Colors.orange,
            ),
          )
        else
          TextButton(
            onPressed: _isResending ? null : _resendOtp,
            child: _isResending
                ? SizedBox(
                    height: 16.h,
                    width: 16.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'إعادة الإرسال',
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
          ),
      ],
    );
  }
}
