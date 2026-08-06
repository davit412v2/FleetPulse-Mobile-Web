import 'package:fleet_pulse/features/authentication/presentation/pages/login_page.dart';
import 'package:fleet_pulse/features/authentication/providers/auth_provider.dart';
import 'package:fleet_pulse/features/dashboard/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (isAuthenticated && isLoginRoute) {
        return AppRoutes.home;
      }

      if (!isAuthenticated && !isLoginRoute) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Página no encontrada: ${state.matchedLocation}'),
      ),
    ),
  );
});