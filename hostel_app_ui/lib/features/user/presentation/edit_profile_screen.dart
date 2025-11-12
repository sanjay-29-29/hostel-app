import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController userNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  HostelModel? selectedHostel;
  RoleModel? selectedRole;
  bool isActive = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    userNameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    isActive = widget.user.isActive;

    final baseInfo = ref.read(authNotifierProvider).baseInfo;
    if (baseInfo != null) {
      _setSelectionFromBaseInfo(baseInfo.hostels, baseInfo.roles);
    }
  }

  void _setSelectionFromBaseInfo(
    List<HostelModel>? hostels,
    List<RoleModel>? roles,
  ) {
    if (roles != null) {
      try {
        final match = roles.firstWhere((r) => r.id == widget.user.role.id);
        selectedRole = match;
      } catch (_) {
        selectedRole = null;
      }
    }

    if (hostels != null) {
      try {
        final match = hostels.firstWhere((h) => h.id == widget.user.hostel.id);
        selectedHostel = match;
      } catch (_) {
        selectedHostel = null;
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ToastHelper.showError('Please fix all validation errors');
      return;
    }
    if (selectedRole == null || selectedHostel == null) {
      ToastHelper.showError('Please select hostel and role');
      return;
    }

    try {
      await ref
          .read(addUserNotifierProvider.notifier)
          .UpdateUser(
            UpdateUserModel(
              id: widget.user.id,
              isNew: false,
              name: userNameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneController.text.trim(),
              isActive: isActive,
              role: selectedRole!.id,
              hostel: selectedHostel!.id,
            ),
          );

      ToastHelper.showSuccess('User updated successfully!');

      router.pop();
      router.pop();
      router.pushNamed(
        RouteConstantsNames.profile,
        extra: {'user': widget.user.id, 'canEdit': true},
      );
    } catch (e) {
      ToastHelper.showError('Failed to update user');
    }
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
        child: PrimaryButton(text: 'UPDATE USER', onPressed: _handleSubmit),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                HeaderSection(title1: 'UPDATE', title2: 'USER PROFILE'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormCard(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ResponsiveText(
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

                        const SizedBox(height: 16),

                        FormCard(
                          children: [
                            CustomDropdownField<HostelModel>(
                              getLabel: (HostelModel h) => h.name,
                              label: 'HOSTEL NAME',
                              hint: 'Select Hostel',
                              value: selectedHostel,
                              items: baseInfo?.hostels ?? [],
                              onChanged: (baseInfo?.hostels != null)
                                  ? (HostelModel? hostel) {
                                      setState(() => selectedHostel = hostel);
                                    }
                                  : null,
                              validator: (value) {
                                if (value == null)
                                  return 'This field is required';
                                return null;
                              },
                            ),

                            CustomDropdownField<RoleModel>(
                              getLabel: (RoleModel role) => role.name,
                              label: 'ROLE',
                              hint: 'Select Role',
                              value: selectedRole,
                              items: baseInfo?.roles ?? [],
                              onChanged: (baseInfo?.roles != null)
                                  ? (RoleModel? role) {
                                      setState(() => selectedRole = role);
                                    }
                                  : null,
                              validator: (value) {
                                if (value == null)
                                  return 'This field is required';
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

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
                              errors: formErrors?.errors['name']?[0],
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
                              errors: formErrors?.errors['email']?[0],
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
                              errors: formErrors?.errors['phone_number']?[0],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (addUserState.isLoading)
              const Opacity(
                opacity: 0.6,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
