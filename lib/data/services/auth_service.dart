import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:october_scada/models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // قائمة المستخدمين المحددين مسبقاً
  final List<User> _predefinedUsers = [
    User(email: 'ibrahimthswd@gmail.com', password: 'iti123456', name: 'ITI'),
  ];

  User? _currentUser;
  final Map<String, OtpSession> _otpSessions = {};
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // التحقق من بيانات تسجيل الدخول
  Future<AuthResult> login(String email, String password) async {
    try {
      final user = _predefinedUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      if (user.password != password) {
        return AuthResult(success: false, message: 'كلمة المرور غير صحيحة');
      }

      if (!user.isActive) {
        return AuthResult(success: false, message: 'الحساب غير نشط');
      }

      // إنشاء OTP وإرساله
      final otpResult = await _generateAndSendOtp(user.email);
      if (!otpResult.success) {
        return otpResult;
      }

      return AuthResult(
        success: true,
        message: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
        requiresOtp: true,
      );
    } catch (e) {
      return AuthResult(success: false, message: 'البريد الإلكتروني غير مسجل');
    }
  }

  // إنشاء وإرسال OTP
  Future<AuthResult> _generateAndSendOtp(String email) async {
    try {
      final otp = _generateOtp();
      final expiryTime = DateTime.now().add(const Duration(minutes: 5));

      _otpSessions[email] = OtpSession(
        email: email,
        otp: otp,
        expiryTime: expiryTime,
      );

      // إرسال OTP عبر الإيميل
      final emailSent = await _sendOtpEmail(email, otp);
      if (!emailSent) {
        return AuthResult(success: false, message: 'فشل في إرسال رمز التحقق');
      }

      return AuthResult(success: true, message: 'تم إرسال رمز التحقق');
    } catch (e) {
      debugPrint('Error generating OTP: $e');
      return AuthResult(success: false, message: 'حدث خطأ في إنشاء رمز التحقق');
    }
  }

  // إنشاء رمز OTP عشوائي
  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // إرسال OTP عبر البريد الإلكتروني
  Future<bool> _sendOtpEmail(String email, String otp) async {
    try {
      // استخدام EmailJS أو أي خدمة إرسال إيميل
      const serviceId = 'your_service_id';
      const templateId = 'your_template_id';
      const publicKey = 'your_public_key';

      final emailData = {
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'to_email': email,
          'otp_code': otp,
          'app_name': 'October SCADA System',
          'expiry_minutes': '5',
        },
      };

      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(emailData),
      );

      if (response.statusCode == 200) {
        debugPrint('OTP sent successfully to $email: $otp');
        return true;
      } else {
        debugPrint('Failed to send OTP: ${response.statusCode}');
        // في بيئة التطوير، اطبع الـ OTP في الكونسول
        if (kDebugMode) {
          debugPrint('Development Mode - OTP for $email: $otp');
          return true;
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error sending OTP email: $e');
      // في بيئة التطوير، اطبع الـ OTP في الكونسول
      if (kDebugMode) {
        debugPrint('Development Mode - OTP for $email: $otp');
        return true;
      }
      return false;
    }
  }

  // التحقق من رمز OTP
  Future<AuthResult> verifyOtp(String email, String enteredOtp) async {
    try {
      final otpSession = _otpSessions[email];

      if (otpSession == null) {
        return AuthResult(success: false, message: 'لم يتم طلب رمز التحقق');
      }

      if (otpSession.isExpired) {
        _otpSessions.remove(email);
        return AuthResult(success: false, message: 'انتهت صلاحية رمز التحقق');
      }

      if (otpSession.otp != enteredOtp) {
        return AuthResult(success: false, message: 'رمز التحقق غير صحيح');
      }

      // تسجيل الدخول بنجاح
      _currentUser = _predefinedUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );

      _isLoggedIn = true;
      _otpSessions.remove(email);
      notifyListeners();

      return AuthResult(
        success: true,
        message: 'تم تسجيل الدخول بنجاح',
        user: _currentUser,
      );
    } catch (e) {
      return AuthResult(success: false, message: 'حدث خطأ في التحقق');
    }
  }

  // إعادة إرسال OTP
  Future<AuthResult> resendOtp(String email) async {
    final user = _predefinedUsers.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('User not found'),
    );

    return await _generateAndSendOtp(user.email);
  }

  // تسجيل الخروج
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _otpSessions.clear();
    notifyListeners();
  }

  // الحصول على قائمة المستخدمين (للاختبار فقط)
  List<User> get predefinedUsers => _predefinedUsers;
}

class AuthResult {
  final bool success;
  final String message;
  final User? user;
  final bool requiresOtp;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.requiresOtp = false,
  });
}
