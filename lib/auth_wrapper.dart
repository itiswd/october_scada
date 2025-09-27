import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/providers/auth_provider.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/main_navigation_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return isLoggedIn ? const MainNavigationPage() : const LoginPage();
  }
}
