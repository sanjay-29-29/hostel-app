import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/auth/notifier/auth_notifier.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class GettingStarted extends ConsumerWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroScaffold(
      body: Column(
        spacing: 40,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ImageConstants.assuringTheBest),
          ResponsiveText(
            'WELCOME',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          Image.asset(ImageConstants.kecLogo),
          ResponsiveText(
            'HOSTEL LIFE MADE EASY',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins',
            ),
          ),
          FilledButton(
            onPressed: () {
              ref.watch(authNotifierProvider.notifier).restoreSession();
            },
            child: ResponsiveText(
              'GET STARTED',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
