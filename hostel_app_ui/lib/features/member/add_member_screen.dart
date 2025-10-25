import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final List<String> hostelNames = ['Illango', 'Kaveri', 'Vaigai', 'Bhavani'];
  final List<String> roles = ['Warden', 'Floor Warden', 'Care Taker'];

  String? selectedHostel;
  String? selectedRole;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ToastHelper.showSuccess('Member added successfully!');
      router.goNamed(RouteConstantsNames.manageMembers);
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
        child: PrimaryButton(text: 'ADD USER', onPressed: _handleSubmit),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'ADD', title2: 'NEW MEMBER'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const ResponsiveSizedBox(height: 24),

                    FormCard(
                      children: [
                        CustomTextField(
                          label: 'USER NAME',
                          hint: 'sathiyaseelan',
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
                          hint: 'abc@gmail.com',
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
                          hint: '9876543210',
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
