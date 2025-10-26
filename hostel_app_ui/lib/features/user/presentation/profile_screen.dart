import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool canEdit;
  const ProfileScreen({super.key, required this.user, this.canEdit = false});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _hostelController = MultiSelectController<HostelModel>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _hostelController.selectAll();
    });
  }

  @override
  void dispose() {
    _hostelController.dispose();
    super.dispose();
  }

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
              user: widget.user,
              canEdit: widget.canEdit,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                spacing: 32,
                children: [
                  FormCard(
                    children: [
                      MultiDropdown<HostelModel>(
                        enabled: false,
                        controller: _hostelController,
                        validator: (value) {
                          if (value == null || value.length == 0)
                            return 'This field is required.';
                          return null;
                        },
                        dropdownDecoration: DropdownDecoration(
                          marginTop: 2,
                        ),
                        chipDecoration: const ChipDecoration(
                          backgroundColor: ColorConstants.bgLight,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                        ),
                        fieldDecoration: FieldDecoration(
                          padding: EdgeInsets.all(0),
                          hintText: 'Select Hostel',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        // onSelectionChange: (items) {
                        //   setState(() {
                        //     _selectedHostels = items;
                        //   });
                        // },
                        items: widget.user.hostel
                            .map(
                              (hostel) => DropdownItem(
                                label: hostel.name,
                                value: hostel,
                              ),
                            )
                            .toList(),
                        key: ValueKey(widget.user.hostel.length),
                      ),
                      CustomTextField(
                        label: 'ROLE',
                        hint: '',
                        controller: TextEditingController(
                          text: widget.user.role,
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
                          text: widget.user.phoneNumber,
                        ),
                        canEdit: false,
                      ),
                      CustomTextField(
                        label: 'EMAIL ADDRESS',
                        hint: 'abc@gmail.com',
                        controller: TextEditingController(
                          text: widget.user.email,
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
