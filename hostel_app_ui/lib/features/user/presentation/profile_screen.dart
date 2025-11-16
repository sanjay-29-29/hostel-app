import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/loading.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_text_field.dart';
import 'package:hostel_app/features/shared/widgets/forms/form_card.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool canEdit;
  final int userId;
  const ProfileScreen({super.key, this.canEdit = false, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _hostelController = MultiSelectController<HostelModel>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(manageUserNotifierProvider.notifier).clearSelectedUser();
      ref
          .read(manageUserNotifierProvider.notifier)
          .fetchUserById(widget.userId);
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
    final manageUserNotifier = ref.watch(manageUserNotifierProvider);
    final user = manageUserNotifier.selectedUser!;

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: manageUserNotifier.isLoading
          ? Center(child: LoadingScreen())
          : SingleChildScrollView(
              child: Column(
                children: [
                  HeaderSection(
                    isProfilePage: true,
                    user: user,
                    canEdit: widget.canEdit,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      spacing: 32,
                      children: [
                        FormCard(
                          children: [
                            CustomTextField(
                              label: 'HOSTEL NAME',
                              hint: '',
                              controller: TextEditingController(
                                text: user.hostels.first.name,
                              ),
                              canEdit: false,
                            ),
                            CustomTextField(
                              label: 'ROLE',
                              hint: '',
                              controller: TextEditingController(
                                text: user.role.name,
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
                                text: user.phoneNumber,
                              ),
                              canEdit: false,
                            ),
                            CustomTextField(
                              label: 'EMAIL ADDRESS',
                              hint: 'abc@gmail.com',
                              controller: TextEditingController(
                                text: user.email,
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
