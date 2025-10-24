import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/members/member_filterbar.dart';
import 'package:hostel_app/features/shared/widgets/members/member_result.dart';
import 'package:hostel_app/features/shared/widgets/members/member_searchbar.dart';

class ManageMemberScreen extends StatefulWidget {
  const ManageMemberScreen({super.key});

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedStatus = 'All';

  final List<Map<String, String>> _members = [
    {
      'name': 'Suresh Babu',
      'role': 'Floor Warden',
      'hostel': 'Ilango',
      'status': 'New',
    },
    {
      'name': 'Ramesh Kumar',
      'role': 'Care Taker',
      'hostel': 'Kaveri',
      'status': 'Active',
    },
    {
      'name': 'Dinesh Raj',
      'role': 'Warden',
      'hostel': 'Vaigai',
      'status': 'Inactive',
    },
    {
      'name': 'Vijay Anand',
      'role': 'Floor Warden',
      'hostel': 'Bhavani',
      'status': 'Active',
    },
    {
      'name': 'Sathiyaseelan',
      'role': 'Care Taker',
      'hostel': 'Ilango',
      'status': 'Inactive',
    },
    {
      'name': 'Manikandan',
      'role': 'Warden',
      'hostel': 'Ilango',
      'status': 'New',
    },
    {
      'name': 'Hari Prasad',
      'role': 'Care Taker',
      'hostel': 'Kaveri',
      'status': 'Active',
    },
    {
      'name': 'Karthik Raja',
      'role': 'Floor Warden',
      'hostel': 'Vaigai',
      'status': 'Inactive',
    },
  ];

  String _sortOrder = 'A-Z';

  void _sortMembers() {
    _members.sort((a, b) {
      final nameA = a['name']!.toLowerCase();
      final nameB = b['name']!.toLowerCase();
      return _sortOrder == 'A-Z'
          ? nameA.compareTo(nameB)
          : nameB.compareTo(nameA);
    });
  }

  List<Map<String, String>> get filteredMembers {
    return _members.where((member) {
      final matchesSearch =
          member['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member['role']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member['hostel']!.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatus == 'All' || member['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.pushNamed(RouteConstantsNames.addMember),
        backgroundColor: ColorConstants.darkRed,
        shape: const CircleBorder(),
        child: Center(
          child: Image.asset(
            IconAssetConstants.addMemberIcon,
            color: Colors.white,
            width: 24,
            height: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          const HeaderSection(title1: 'MANAGE', title2: 'MEMBERS'),

          MemberSearchBar(
            controller: _searchController,
            onChanged: (value) => setState(() => searchQuery = value),
            onClear: () => setState(() => searchQuery = ''),
            memberCount: _members.length,
          ),

          MemberFilterBar(
            selectedStatus: selectedStatus,
            sortOrder: _sortOrder,
            onStatusChanged: (value) => setState(() => selectedStatus = value),
            onSortChanged: (value) => setState(() {
              _sortOrder = value;
              _sortMembers();
            }),
          ),

          Expanded(
            child: MemberList(
              members: filteredMembers,
              searchQuery: searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}
