import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/date_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/student_count_selection.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/waste_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/date_selector.dart';
import 'package:hostel_app/features/waste/model/waste_create.dart';

class WasteManageScreen extends ConsumerStatefulWidget {
  const WasteManageScreen({super.key});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  DateTime selectedDate = DateTime.now();
  TimingModel? _timing;

  final coffeeWasteController = TextEditingController();
  final studentWasteController = TextEditingController();
  final cookedWasteController = TextEditingController();
  final milkWasteController = TextEditingController();

  double coffeeInLiters = 0;

  @override
  void initState() {
    super.initState();
    _clearControllers();
  }

  @override
  void dispose() {
    coffeeWasteController.dispose();
    studentWasteController.dispose();
    cookedWasteController.dispose();
    milkWasteController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    coffeeWasteController.clear();
    studentWasteController.clear();
    cookedWasteController.clear();
    milkWasteController.clear();
  }

  void _handleDateChange(DateTime d) {
    setState(() {
      selectedDate = d;
      // resetting timing when date change
      _timing = null;
    });
  }

  void _handleWasteCreationOrUpdate() {
    final wasteNotifer = ref.watch(wasteManageNotifierProvider.notifier);
    final wasteState = ref.read(wasteManageNotifierProvider);
    if (wasteState.waste == null) {
      wasteNotifer.addWaste(
        WasteCreateModel(
          timing: _timing!.id,
          coffeWaste: int.tryParse(coffeeWasteController.text),
          foodCookedWaste: int.tryParse(cookedWasteController.text),
          studentWaste: int.tryParse(studentWasteController.text),
          date: selectedDate,
          studentsPresent: 120,
        ),
      );
      return;
    }
    wasteNotifer.updateWaste(
      wasteState.waste!.id,
      WasteCreateModel(
        timing: _timing!.id,
        coffeWaste: int.tryParse(coffeeWasteController.text),
        foodCookedWaste: int.tryParse(cookedWasteController.text),
        studentWaste: int.tryParse(studentWasteController.text),
        date: selectedDate,
        studentsPresent: 120,
      ),
    );
  }

  void _updateControllersFromWaste() {
    final waste = ref.read(wasteManageNotifierProvider).waste;
    if (waste != null) {
      cookedWasteController.text = waste.foodCookedWaste?.toString() ?? '';
      studentWasteController.text = waste.studentWaste?.toString() ?? '';
      milkWasteController.text = waste.coffeWaste?.toString() ?? '';
    } else {
      _clearControllers();
    }
  }

  void _handleDateAndTimingChange() async {
    if (_timing == null) return;
    await ref
        .read(wasteManageNotifierProvider.notifier)
        .fetchWaste(selectedDate, _timing!);
    _updateControllersFromWaste();
  }

  @override
  Widget build(BuildContext context) {
    final baseInfo = ref.watch(authNotifierProvider).baseInfo;
    final wasteState = ref.watch(wasteManageNotifierProvider);

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'FOOD', title2: 'MANAGEMENT'),
            const ResponsiveSizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                children: [
                  DateSection(
                    selectedDate: selectedDate,
                    onDateChanged: _handleDateChange,
                  ),
                  DateSelector(
                    selectedDate: selectedDate,
                    onSelect: _handleDateChange,
                  ),
                  CustomDropdownField<TimingModel>(
                    label: 'Select Meal Time',
                    hint: 'Choose a meal time',
                    items: baseInfo?.timings ?? [],
                    value: _timing,
                    getLabel: (meal) => meal.name,
                    onChanged: baseInfo?.timings != null
                        ? (val) {
                            setState(() {
                              _timing = val;
                            });
                            _handleDateAndTimingChange();
                          }
                        : null,
                  ),
                  if (wasteState.isFetching)
                    Container(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    )
                  else if (_timing != null)
                    Column(
                      children: [
                        if (wasteState.waste?.createdBy != null)
                          Align(
                            alignment: AlignmentGeometry.topLeft,
                            child: Text(
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              'Last updated by ${wasteState.waste?.updatedBy}',
                            ),
                          ),
                        StudentCountSection(
                          hostelTotals: {'Ilango': 120, 'Kamban': 90},
                        ),
                        WasteSection(
                          coffeeWasteController: coffeeWasteController,
                          selectedTiming: _timing,
                          studentWasteController: studentWasteController,
                          cookedWasteController: cookedWasteController,
                          milkWasteController: milkWasteController,
                        ),
                        PrimaryButton(
                          text: 'Save',
                          onPressed: (_timing != null && !wasteState.isCreating)
                              ? _handleWasteCreationOrUpdate
                              : null,
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
