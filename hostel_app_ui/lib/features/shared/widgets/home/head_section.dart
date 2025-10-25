import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';

class HomeHeader extends StatelessWidget {
  final ManageMember member;
  const HomeHeader({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      width: 414,
      height: 300,
      decoration: BoxDecoration(
        color: ColorConstants.bgDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(ImageConstants.gridImage, fit: BoxFit.cover),
          ),
          Positioned(
            top: 34,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.login_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ),
          Positioned(
            top: 100,
            left: 24,
            child: ResponsiveContainer(
              width: 366,
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: ColorConstants.profileBlue,
                        child: ResponsiveText(
                          member.name.isNotEmpty
                              ? member.name.trim()[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: (member.status.toLowerCase() == 'active')
                              ? Colors.green
                              : Colors.red,

                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  ResponsiveText(
                    'Welcome ${member.name}',
                    style: TextStyle(
                      fontSize: member.name.length > 10 ? 24 : 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ResponsiveText(
                    '${member.hostel}  - ${member.role}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
