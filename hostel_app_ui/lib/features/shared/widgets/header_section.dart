import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/image_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';

class HeaderSection extends StatelessWidget {
  final String title1;
  final String title2;
  final bool isProfilePage;
  final ManageMember? member;
  final bool canEdit;
  HeaderSection({
    this.title1 = 'Title1',
    this.title2 = 'Title2',
    this.isProfilePage = false,
    this.member,
    this.canEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      height: isProfilePage ? 362 : 200,
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
            child: Image.asset(ImageConstants.gridImage, fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            left: 24,
            child: ResponsiveContainer(
              width: 366,
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => router.pop(),
                    borderRadius: BorderRadius.circular(8),
                    child: ResponsiveContainer(
                      width: 24,
                      height: 24,
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
                  if (isProfilePage && canEdit)
                    InkWell(
                      onTap: () => router.pushNamed(
                        RouteConstantsNames.editProfile,
                        extra: member,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: ResponsiveContainer(
                        width: 72,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: Colors.black26,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Image.asset(
                                IconAssetConstants.editIcon,
                                color: Colors.black,
                                width: 20,
                                height: 20,
                              ),
                              ResponsiveText(
                                'EDIT',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isProfilePage)
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
          if (isProfilePage)
            Positioned(
              top: 100,
              left: 24,
              child: ResponsiveContainer(
                width: 366,
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: ColorConstants.profileBlue,
                          child: ResponsiveText(
                            member != null && member!.name.isNotEmpty
                                ? member!.name.trim()[0].toUpperCase()
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
                            color: (member?.status.toLowerCase() == 'active')
                                ? Colors.green
                                : (member?.status.toLowerCase() == 'inactive')
                                ? Colors.red
                                : Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ],
                    ),
                    ResponsiveText(
                      member?.name ?? 'SAMPLE NAME',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: (member?.status.toLowerCase() == 'active')
                                  ? Colors.green
                                  : (member?.status.toLowerCase() == 'inactive')
                                  ? Colors.red
                                  : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          ResponsiveText(
                            (member?.status != null &&
                                    member!.status.isNotEmpty)
                                ? '${member!.status[0].toUpperCase()}${member!.status.substring(1).toLowerCase()}'
                                : 'New',
                            style: TextStyle(
                              fontSize: 14,
                              color: (member?.status.toLowerCase() == 'active')
                                  ? Colors.green
                                  : (member?.status.toLowerCase() == 'inactive')
                                  ? Colors.red
                                  : Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
