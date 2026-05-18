import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loven/presentation/splash/splash_screen.dart';
import '../../features/navigation/screen/navigation_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NavigationScreen(),
    ),
    GoRoute(
      path: '/splash_screen',
      builder: (context, state) => const SplashScreen(),
    )
  ],
);
