import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      router.goNamed(RouteConstantsNames.gettingStarted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroScaffold(
      body: Center(child: Image.asset(ImageConstants.kecLogo)),
    );
  }
}
