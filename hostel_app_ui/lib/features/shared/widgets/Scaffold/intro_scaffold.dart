import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';

class IntroScaffold extends StatelessWidget {
  Widget body;

  IntroScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Image.asset(ImageConstants.scaffoldDecoration),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: SingleChildScrollView(child: body)),
          ),
        ],
      ),
    );
  }
}
