import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/features/home/presentation/home_screen.dart';
import 'package:hostel_app/features/user/presentation/add_user_screen.dart';
import 'package:hostel_app/features/user/presentation/manage_user_screen.dart';
import 'package:hostel_app/features/auth/presentation/getting_started_screen.dart';
import 'package:hostel_app/features/auth/presentation/login_screen.dart';
import 'package:hostel_app/features/auth/presentation/signup_screen.dart';
import 'package:hostel_app/features/waste/presentation/report_screen.dart';
import 'package:hostel_app/features/waste/presentation/waste_manage_screen.dart';
import 'package:hostel_app/features/user/presentation/profile_screen.dart';
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
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: RouteConstants.addMember,
      name: RouteConstantsNames.addMember,
      builder: (context, state) => const AddUserScreen(),
    ),
    GoRoute(
      path: RouteConstants.manageMembers,
      name: RouteConstantsNames.manageMembers,
      builder: (context, state) => const ManageUserScreen(),
    ),
    GoRoute(
      path: RouteConstants.wasteManage,
      name: RouteConstantsNames.wasteManage,
      builder: (context, state) => const WasteManageScreen(),
    ),
    GoRoute(
      path: RouteConstants.reportView,
      name: RouteConstantsNames.reportView,
      builder: (context, state) => const ReportViewScreen(),
    ),
    GoRoute(
      path: RouteConstants.profile,
      name: RouteConstantsNames.profile,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ProfileScreen(user: data['user'], canEdit: data['canEdit']);
      },
    ),
    // GoRoute(
    //   path: RouteConstants.editProfile,
    //   name: RouteConstantsNames.editProfile,
    //   builder: (context, state) {EditProfileScreen(member: member);
    // ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found'))),
);
