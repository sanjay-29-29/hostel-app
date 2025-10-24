import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onBackPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onBackPressed ?? () => router.pop(),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: Image.asset(
                IconAssetConstants.leftArrowIcon,
                color: Colors.black,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
    
        InkWell(
          onTap: onPressed,
          child: ResponsiveContainer(
            color: ColorConstants.darkRed,
            width: 294,
            height: 52,
            child: Center(
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveText(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Image.asset(
                      IconAssetConstants.leftArrowIcon,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
