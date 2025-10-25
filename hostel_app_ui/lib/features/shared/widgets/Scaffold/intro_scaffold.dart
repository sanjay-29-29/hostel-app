import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';


class IntroScaffold extends StatefulWidget {
  final Widget body;

  IntroScaffold({super.key, required this.body});

  @override
  State<IntroScaffold> createState() => _IntroScaffoldState();
}

class _IntroScaffoldState extends State<IntroScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Image.asset(ImageConstants.scaffoldDecoration),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: SingleChildScrollView(child: widget.body)),
          ),
        ],
      ),
    );
  }
}
