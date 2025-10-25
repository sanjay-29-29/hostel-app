import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';
import 'package:hostel_app/features/user/notifier/add_user_notifier.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hostelController = MultiSelectController<HostelModel>();
  final _passwordController = TextEditingController();

  RoleModel? _selectedRole;
  List<HostelModel> _selectedHostels = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addUserNotifierProvider.notifier).fetchCreateInfo();
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _hostelController.dispose();

    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    bool status = await ref.read(addUserNotifierProvider.notifier).createUser(
          CreateUserModel(
            phoneNumber: _phoneController.text,
            email: _emailController.text,
            name: _userNameController.text,
            password: _passwordController.text,
            role: _selectedRole!.id,
            hostels: _selectedHostels.map((ele) => ele.id).toList(),
          ),
        );
    if (status) {
      print(status);
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final addUserState = ref.watch(addUserNotifierProvider);
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
                            ResponsiveText(
                              'HOSTEL',
                              style: TextStyle(
                                color: ColorConstants.darkRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            MultiDropdown<HostelModel>(
                              validator: (value) {
                                if (value == null)
                                  return 'This field is required.';
                                return null;
                              },
                              dropdownDecoration:
                                  DropdownDecoration(marginTop: 0),
                              fieldDecoration: FieldDecoration(
                                padding: EdgeInsets.all(0),
                                hintText: 'Select Hostel',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              onSelectionChange: (items) {
                                setState(() {
                                  _selectedHostels = items;
                                });
                              },
                              items: addUserState.hostels
                                  .map(
                                    (hostel) => DropdownItem(
                                      label: hostel.name,
                                      value: hostel,
                                    ),
                                  )
                                  .toList(),
                              key: ValueKey(addUserState.hostels.length),
                            ),
                          ],
                        ),
                        CustomDropdownField<RoleModel>(
                          label: 'ROLE',
                          hint: 'Select Role',
                          items: addUserState.roles,
                          value: _selectedRole,
                          getLabel: (RoleModel? role) => role?.name ?? '',
                          onChanged: (RoleModel? role) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
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
                          hint: 'sathiyaseelan',
                          controller: _userNameController,
                          errors: formErrors?.errors['name']?[0],
                        ),
                        CustomTextField(
                          label: 'EMAIL ADDRESS',
                          hint: 'abc@gmail.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errors: formErrors?.errors['email']?[0],
                        ),
                        CustomTextField(
                          label: 'PHONE NUMBER',
                          hint: '9876543210',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          errors: formErrors?.errors['phone_number']?[0],
                        ),
                        CustomTextField(
                          label: 'PASSWORD',
                          hint: '',
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
