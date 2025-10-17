import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
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
          Text(
            'WELCOME',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          Image.asset(ImageConstants.kecLogo),
          Text(
            'HOSTEL LIFE MADE EASY',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          FilledButton(
            onPressed: () {
              context.goNamed('login');
            },
            child: Text(
              'GET STARTED',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
