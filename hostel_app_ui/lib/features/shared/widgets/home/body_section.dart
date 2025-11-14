import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

class HomeBody extends StatelessWidget {
  final UserModel user;
  const HomeBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 40,
        crossAxisSpacing: 30,
        children: [
          _buildMenuCard(
            context,
            imagePath: IconAssetConstants.foodIcon,
            title1: 'FOOD',
            title2: 'MANAGEMENT',
            onTap: () {
              router.pushNamed(
                RouteConstantsNames.wasteManage,
                extra: {'kitchen': user.kitchens[0]},
              );
            },
          ),
          _buildMenuCard(
            context,
            imagePath: IconAssetConstants.attendanceIcon,
            title1: 'STUDENTS',
            title2: 'RECORD',
            onTap: () {},
          ),
          _buildMenuCard(
            context,
            imagePath: IconAssetConstants.usersIcon,
            title1: 'MANAGE',
            title2: 'USERS',
            onTap: () {
              router.pushNamed(RouteConstantsNames.manageMembers);
            },
          ),
          _buildMenuCard(
            context,
            imagePath: IconAssetConstants.profileIcon,
            title1: 'VIEW MY',
            title2: 'PROFILE',
            onTap: () {
              router.pushNamed(
                RouteConstantsNames.profile,
                extra: {'user': user.id, 'canEdit': false},
              );
            },
          ),
          _buildMenuCard(
            context,
            imagePath: IconAssetConstants.foodIcon,
            title1: 'REPORT',
            title2: 'VIEW',
            onTap: () {
              router.pushNamed(
                RouteConstantsNames.reportView,
                extra: {'member': user, 'canEdit': false},
              );
            },
          ),
        ],
      ),
    );
  }

Widget _buildMenuCard(
  BuildContext context, {
  required String imagePath,
  required String title1,
  required String title2,
  required VoidCallback onTap,
}) {

  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imagePath,
          width: 100,
          height: 100,
          placeholderBuilder: (context) => SizedBox(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          semanticsLabel: '$title1 $title2',
        ),
        const SizedBox(height: 10),
        ResponsiveText(title1, style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.2)),
        ResponsiveText(title2, style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.2)),
      ],
    ),
  );
}
}
