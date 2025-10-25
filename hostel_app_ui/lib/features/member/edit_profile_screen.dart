import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/shared/models/member/member_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  final ManageMember member;
  const EditProfileScreen({super.key, required this.member});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> hostelNames = ['Ilango', 'Kaveri', 'Vaigai', 'Bhavani'];
  final List<String> roles = ['Warden', 'Floor Warden', 'Care Taker'];

  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String? selectedHostel;
  String? selectedRole;
  bool isActive = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.member.name);
    emailController = TextEditingController(text: widget.member.email);
    phoneController = TextEditingController(text: widget.member.phoneNumber);
    selectedHostel = widget.member.hostel;
    selectedRole = widget.member.role;
    isActive = widget.member.status != 'Inactive';
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final updatedMember = widget.member.copyWith(
        name: userNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        hostel: selectedHostel ?? widget.member.hostel,
        role: selectedRole ?? widget.member.role,
        status: isActive ? 'Active' : 'Inactive',
      );
      debugPrint('--- Updated Member ---');
      debugPrint('Name: ${updatedMember.name}');
      debugPrint('Email: ${updatedMember.email}');
      debugPrint('Phone: ${updatedMember.phoneNumber}');
      debugPrint('Hostel: ${updatedMember.hostel}');
      debugPrint('Role: ${updatedMember.role}');
      debugPrint('Status: ${updatedMember.status}');
      debugPrint('-----------------------');

      ToastHelper.showSuccess('Member updated successfully!');

      router.pop();
      router.pop();
      router.pushNamed(
        RouteConstantsNames.profile,
        extra: {'member': updatedMember, 'canEdit': true},
      );
    } else {
      ToastHelper.showError('Please fix all validation errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: PrimaryButton(text: 'UPDATE USER', onPressed: _handleSubmit),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'UPDATE', title2: 'USER PROFILE'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  spacing: 32,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormCard(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isActive ? 'User Active' : 'User Deactivated',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ),
                            CupertinoSwitch(
                              value: isActive,
                              activeColor: Colors.green,
                              onChanged: (bool value) {
                                setState(() {
                                  isActive = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    FormCard(
                      children: [
                        CustomDropdownField(
                          label: 'HOSTEL NAME',
                          hint: 'Select Hostel',
                          value: selectedHostel,
                          items: hostelNames,
                          onChanged: (val) =>
                              setState(() => selectedHostel = val),
                          validator: (val) =>
                              val == null ? 'Please select a hostel' : null,
                        ),
                        CustomDropdownField(
                          label: 'ROLE',
                          hint: 'Select Role',
                          value: selectedRole,
                          items: roles,
                          onChanged: (val) =>
                              setState(() => selectedRole = val),
                          validator: (val) =>
                              val == null ? 'Please select a role' : null,
                        ),
                      ],
                    ),

                    FormCard(
                      children: [
                        CustomTextField(
                          label: 'USER NAME',
                          hint: 'Enter user name',
                          controller: userNameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Username is required';
                            } else if (val.length < 4) {
                              return 'Username must be at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          label: 'EMAIL ADDRESS',
                          hint: 'Enter Email Address',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Email is required';
                            } else if (!val.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          label: 'PHONE NUMBER',
                          hint: 'Enter Phone Number',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Phone number is required';
                            } else if (val.length != 10) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
