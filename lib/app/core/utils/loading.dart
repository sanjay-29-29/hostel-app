import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: ColorConstants.primaryColor,
        size: 50,
      ),
    );
  }
}
