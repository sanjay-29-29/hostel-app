import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class MemberList extends StatelessWidget {
  final List<Map<String, String>> members;
  final String searchQuery;

  const MemberList({
    super.key,
    required this.members,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filteredMembers = members.where((member) {
      final query = searchQuery.toLowerCase();
      final name = member['name']!.toLowerCase();
      final role = member['role']!.toLowerCase();
      final hostel = member['hostel']!.toLowerCase();
      return name.contains(query) ||
          role.contains(query) ||
          hostel.contains(query);
    }).toList();

    if (filteredMembers.isEmpty) {
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
      itemCount: filteredMembers.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Colors.black12),
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        final name = member['name'] ?? '';
        final firstLetter = name.isNotEmpty
            ? name.trim()[0].toUpperCase()
            : '?';

        return ListTile(
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
            '${member['role']}, ${member['hostel']}',
            style: const TextStyle(color: Color(0xFF686868), fontSize: 14),
          ),
        );
      },
    );
  }
}
