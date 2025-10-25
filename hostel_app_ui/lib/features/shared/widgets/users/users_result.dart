import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

class MemberList extends StatelessWidget {
  final List<UserModel> users;

  const MemberList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: ResponsiveText(
            'No members found.',
            style: TextStyle(fontSize: 16, color: Color(0xFF686868)),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: users.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Colors.black12),
      itemBuilder: (context, index) {
        final user = users[index];
        final name = user.name;
        final firstLetter = name.isNotEmpty
            ? name.trim()[0].toUpperCase()
            : '?';

        return InkWell(
          onTap: () {
            router.pushNamed(
              RouteConstantsNames.profile,
              extra: {'member': user, 'canEdit': true},
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: CircleAvatar(
              radius: 32,
              backgroundColor: ColorConstants.profileColor,
              child: ResponsiveText(
                firstLetter,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: ResponsiveText(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: ResponsiveText(
              '${user.role}',
              style: const TextStyle(color: Color(0xFF686868), fontSize: 14),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: user.isActive
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: user.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
