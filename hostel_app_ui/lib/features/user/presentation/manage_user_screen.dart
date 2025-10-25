import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/users/users_filterbar.dart';
import 'package:hostel_app/features/shared/widgets/users/users_result.dart';
import 'package:hostel_app/features/shared/widgets/users/users_searchbar.dart';
import 'package:hostel_app/features/user/notifier/manage_user_notifier.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  const ManageUserScreen({super.key});

  @override
  ConsumerState<ManageUserScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends ConsumerState<ManageUserScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(manageUserNotifierProvider.notifier).fetchUsers();
    });
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
            onChanged: manageUserNotifier.searchUsers,
            onClear: manageUserNotifier.clearSearch,
            memberCount: manageUserState.filteredUsers.length,
          ),
          MemberFilterBar(
            leftDropdown: SelectedStatus.values,
            leftSelectedValue: manageUserState.selectedStatus,
            leftChanged: manageUserNotifier.filterByStatus,
            rightDropdownValue: SortOrder.values,
            rightSelectedValue: manageUserState.sortOrder,
            rightChanged: manageUserNotifier.sort,
          ),
          Expanded(child: MemberList(users: manageUserState.filteredUsers)),
        ],
      ),
    );
  }
}
