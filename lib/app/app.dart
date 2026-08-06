import 'package:fleet_pulse/app/routes/app_router.dart';
import 'package:fleet_pulse/app/theme/app_theme.dart';
import 'package:fleet_pulse/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aplicación principal de FleetPulse
class FleetPulseApp extends ConsumerWidget {
  const FleetPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}