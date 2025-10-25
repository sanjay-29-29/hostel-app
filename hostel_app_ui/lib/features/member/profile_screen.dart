import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';

class ProfileScreen extends StatefulWidget {
  final ManageMember member;
  final bool canEdit;
  const ProfileScreen({super.key, required this.member, this.canEdit = false});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,

      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(
              title1: 'ADD',
              title2: 'NEW MEMBER',
              isProfilePage: true,
              member: widget.member,
              canEdit: widget.canEdit,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                spacing: 32,
                children: [
                  FormCard(
                    children: [
                      CustomTextField(
                        label: 'HOSTEL NAME',
                        hint: '',
                        controller: TextEditingController(
                          text: widget.member.hostel,
                        ),
                        canEdit: false,
                      ),
                      CustomTextField(
                        label: 'ROLE',
                        hint: '',
                        controller: TextEditingController(
                          text: widget.member.role,
                        ),
                        canEdit: false,
                      ),
                    ],
                  ),
                  FormCard(
                    children: [
                      CustomTextField(
                        label: 'PHONE NUMBER',
                        hint: '9876543210',
                        controller: TextEditingController(
                          text: widget.member.phoneNumber,
                        ),
                        canEdit: false,
                      ),
                      CustomTextField(
                        label: 'EMAIL ADDRESS',
                        hint: 'abc@gmail.com',
                        controller: TextEditingController(
                          text: widget.member.email,
                        ),
                        canEdit: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
