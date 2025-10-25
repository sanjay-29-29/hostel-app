import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';
import 'package:hostel_app/features/shared/widgets/home/body_section.dart';
import 'package:hostel_app/features/shared/widgets/home/head_section.dart';

class HomeScreen extends StatefulWidget {
  final ManageMember member;
  const HomeScreen({super.key, required this.member});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: Column(
        children: [
          HomeHeader(member: widget.member),
          ResponsiveSizedBox(height: 24),
          Expanded(child: HomeBody(member: widget.member)),
        ],
      ),
    );
  }
}
