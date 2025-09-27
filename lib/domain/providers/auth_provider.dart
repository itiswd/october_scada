import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:october_scada/data/services/auth_service.dart';

final authProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final currentUserProvider = Provider((ref) {
  return ref.watch(authProvider).currentUser;
});
