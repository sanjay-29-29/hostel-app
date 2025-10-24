import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/features/home/presentation/home_screen.dart';
import 'package:hostel_app/features/login/presentation/getting_started_screen.dart';
import 'package:hostel_app/features/login/presentation/login_screen.dart';
import 'package:hostel_app/features/login/presentation/signup_screen.dart';
import 'package:hostel_app/splash.dart';

final router = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      name: RouteConstantsNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteConstants.gettingStarted,
      name: RouteConstantsNames.gettingStarted,
      builder: (context, state) => const GettingStarted(),
    ),
    GoRoute(
      path: RouteConstants.login,
      name: RouteConstantsNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteConstants.signup,
      name: RouteConstantsNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: RouteConstants.home,
      name: RouteConstantsNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found'))),
);
