import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class HeaderSection extends StatelessWidget {
  final String title1;
  final String title2;
  const HeaderSection({required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstants.bgDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImageConstants.gridImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 34,
            left: 24,
            child: InkWell(
              onTap: () => router.pop(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    IconAssetConstants.leftArrowIcon,
                    color: Colors.black,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ResponsiveText(
                  title1,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                ResponsiveText(
                  title2,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
