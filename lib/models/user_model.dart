class User {
  final String email;
  final String password;
  final String name;
  final bool isActive;

  User({
    required this.email,
    required this.password,
    required this.name,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}

class OtpSession {
  final String email;
  final String otp;
  final DateTime expiryTime;
  final bool isVerified;

  OtpSession({
    required this.email,
    required this.otp,
    required this.expiryTime,
    this.isVerified = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
