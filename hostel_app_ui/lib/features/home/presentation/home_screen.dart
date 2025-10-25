import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/auth/notifier/auth_notifier.dart';
import 'package:hostel_app/features/shared/widgets/home/body_section.dart';
import 'package:hostel_app/features/shared/widgets/home/head_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authNotifierProvider);
    final user = authNotifier.user;

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: Column(
        children: [
          HomeHeader(user: user!),
          ResponsiveSizedBox(height: 24),
          Expanded(child: HomeBody(user: user)),
        ],
      ),
    );
  }
}
