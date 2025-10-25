import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/assets_constants.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';
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
  String _sortOrder = 'A-Z';

  final List<ManageMember> _members = [
    ManageMember(
      name: 'Suresh Babu',
      role: 'Floor Warden',
      hostel: 'Ilango',
      status: 'New',
      phoneNumber: '9876543210',
      email: 'suresh.babu@example.com',
    ),
    ManageMember(
      name: 'Ramesh Kumar',
      role: 'Care Taker',
      hostel: 'Kaveri',
      status: 'Active',
      phoneNumber: '9876501234',
      email: 'ramesh.kumar@example.com',
    ),
    ManageMember(
      name: 'Dinesh Raj',
      role: 'Warden',
      hostel: 'Vaigai',
      status: 'Inactive',
      phoneNumber: '9876512345',
      email: 'dinesh.raj@example.com',
    ),
    ManageMember(
      name: 'Vijay Anand',
      role: 'Floor Warden',
      hostel: 'Bhavani',
      status: 'Active',
      phoneNumber: '9876523456',
      email: 'vijay.anand@example.com',
    ),
    ManageMember(
      name: 'Sathiyaseelan',
      role: 'Care Taker',
      hostel: 'Ilango',
      status: 'Inactive',
      phoneNumber: '9876534567',
      email: 'sathiyaseelan@example.com',
    ),
    ManageMember(
      name: 'Manikandan',
      role: 'Warden',
      hostel: 'Ilango',
      status: 'New',
      phoneNumber: '9876545678',
      email: 'manikandan@example.com',
    ),
    ManageMember(
      name: 'Hari Prasad',
      role: 'Care Taker',
      hostel: 'Kaveri',
      status: 'Active',
      phoneNumber: '9876556789',
      email: 'hari.prasad@example.com',
    ),
    ManageMember(
      name: 'Karthik Raja',
      role: 'Floor Warden',
      hostel: 'Vaigai',
      status: 'Inactive',
      phoneNumber: '9876567890',
      email: 'karthik.raja@example.com',
    ),
  ];
  void _sortMembers() {
    _members.sort((a, b) {
      final nameA = a.name.toLowerCase();
      final nameB = b.name.toLowerCase();
      return _sortOrder == 'A-Z'
          ? nameA.compareTo(nameB)
          : nameB.compareTo(nameA);
    });
  }

  List<ManageMember> get filteredMembers {
    return _members.where((member) {
      final matchesSearch =
          member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member.role.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member.hostel.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatus == 'All' || member.status == selectedStatus;

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
          HeaderSection(title1: 'MANAGE', title2: 'MEMBERS'),

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
