import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/members/member_filterbar.dart';
import 'package:hostel_app/features/shared/widgets/members/member_result.dart';
import 'package:hostel_app/features/shared/widgets/members/member_searchbar.dart';
import 'package:hostel_app/features/user/notifier/user_notifier.dart';

class ManageMemberScreen extends ConsumerStatefulWidget {
  const ManageMemberScreen({super.key});

  @override
  ConsumerState<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends ConsumerState<ManageMemberScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(manageUserNotifierProvider.notifier).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final manageUserState = ref.watch(manageUserNotifierProvider);
    final manageUserNotifier = ref.read(manageUserNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.pushNamed(RouteConstantsNames.addMember),
        backgroundColor: ColorConstants.darkRed,
        shape: const CircleBorder(),
        child: Center(child: Icon(Icons.person_add, color: Colors.white)),
      ),
      body: Column(
        children: [
          HeaderSection(title1: 'MANAGE', title2: 'USERS'),
          MemberSearchBar(
            controller: _searchController,
            onChanged: (value) {
              manageUserNotifier.searchUsers(value);
            },
            onClear: () => manageUserNotifier.clearSearch(),
            memberCount: manageUserState.filteredUsers.length,
          ),
          MemberFilterBar(
            leftDropdown: SelectedStatus.values,
            leftSelectedValue: SelectedStatus.Inactive,
            leftChanged: (SelectedStatus? s) {},
            rightDropdownValue: SortOrder.values,
            rightSelectedValue: SortOrder.Ascending,
            rightChanged: (SortOrder? s) {},
          ),
          Expanded(child: MemberList(users: manageUserState.filteredUsers)),
        ],
      ),
    );
  }
}
