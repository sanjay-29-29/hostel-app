import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  RoleModel? _selectedRole;
  HostelModel? _selectedHostel;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(addUserNotifierProvider.notifier).createUser(
          CreateUserModel(
            phoneNumber: _phoneController.text,
            email: _emailController.text,
            name: _userNameController.text,
            password: _passwordController.text,
            role: _selectedRole!.id,
            hostel: _selectedHostel!.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final addUserState = ref.watch(addUserNotifierProvider);
    final baseInfo = ref.watch(authNotifierProvider).baseInfo;

    final formErrors = addUserState.error;

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: PrimaryButton(text: 'ADD USER', onPressed: _handleSubmit),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'ADD', title2: 'USER'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormCard(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownField<HostelModel>(
                              label: 'HOSTEL',
                              hint: 'Select Hostel',
                              items: baseInfo?.hostels ?? [],
                              value: _selectedHostel,
                              getLabel: (HostelModel hostel) => hostel.name,
                              onChanged: baseInfo?.hostels != null
                                  ? (HostelModel? hostel) {
                                      setState(() {
                                        _selectedHostel = hostel;
                                      });
                                    }
                                  : null,
                              validator: (value) {
                                if (value == null) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        CustomDropdownField<RoleModel>(
                          label: 'ROLE',
                          hint: 'Select Role',
                          items: baseInfo?.roles ?? [],
                          value: _selectedRole,
                          getLabel: (RoleModel role) => role.name,
                          onChanged: baseInfo?.roles != null
                              ? (RoleModel? role) {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                }
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const ResponsiveSizedBox(height: 24),
                    FormCard(
                      children: [
                        CustomTextField(
                          label: 'USER NAME',
                          hint: 'Enter Username',
                          controller: _userNameController,
                          errors: formErrors?.errors['name']?[0],
                        ),
                        CustomTextField(
                          label: 'EMAIL ADDRESS',
                          hint: 'Enter email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errors: formErrors?.errors['email']?[0],
                        ),
                        CustomTextField(
                          label: 'PHONE NUMBER',
                          hint: 'Enter phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          errors: formErrors?.errors['phone_number']?[0],
                        ),
                        CustomTextField(
                          label: 'PASSWORD',
                          hint: 'Enter password',
                          controller: _passwordController,
                          errors: formErrors?.errors['password']?[0],
                          obscureText: true,
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
