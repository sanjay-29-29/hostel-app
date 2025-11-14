import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/loading.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/kitchen/kitchen_model.dart';
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
  final KitchenModel kitchen;
  const WasteManageScreen({super.key, required this.kitchen});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  DateTime selectedDate = DateTime.now();
  Map<HostelModel, int> attendances = {};
  Map<int, HostelModel> hostelIdMap = {};
  TimingModel? timing;

  final coffeeWasteController = TextEditingController();
  final studentWasteController = TextEditingController();
  final cookedWasteController = TextEditingController();
  final milkWasteController = TextEditingController();

  double coffeeInLiters = 0;

  @override
  void initState() {
    widget.kitchen.hostels.map((hostel) {
      hostelIdMap[hostel.id] = hostel;
    });
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
      timing = null;
    });
  }

  void _handleWasteCreationOrUpdate() {
    final wasteNotifer = ref.watch(wasteManageNotifierProvider.notifier);
    final wasteState = ref.read(wasteManageNotifierProvider);
    if (wasteState.waste == null) {
      wasteNotifer.addWaste(
        WasteCreateModel(
          kitchen: widget.kitchen.id,
          timing: timing!.id,
          coffeWaste: int.tryParse(coffeeWasteController.text),
          foodCookedWaste: int.tryParse(cookedWasteController.text),
          studentWaste: int.tryParse(studentWasteController.text),
          date: selectedDate,
          attendances: attendances.entries
              .map(
                (val) => AttendanceCreateModel(
                  hostelId: val.key.id,
                  studentsAbsent: attendances[val.key] ?? 0,
                  studentsPresent:
                      val.key.studentsCount - attendances[val.key]!,
                ),
              )
              .toList(),
        ),
      );
      return;
    }
    wasteNotifer.updateWaste(
      wasteState.waste!.id,
      WasteCreateModel(
        kitchen: widget.kitchen.id,
        timing: timing!.id,
        coffeWaste: int.tryParse(coffeeWasteController.text),
        foodCookedWaste: int.tryParse(cookedWasteController.text),
        studentWaste: int.tryParse(studentWasteController.text),
        attendances: attendances.entries
            .map(
              (val) => AttendanceCreateModel(
                hostelId: val.key.id,
                studentsAbsent: attendances[val.key] ?? 0,
                studentsPresent: val.key.studentsCount - attendances[val.key]!,
              ),
            )
            .toList(),
        date: selectedDate,
      ),
    );
  }

  void _updateControllersFromWaste() {
    final waste = ref.read(wasteManageNotifierProvider).waste;
    if (waste != null) {
      cookedWasteController.text = waste.foodCookedWaste?.toString() ?? '';
      studentWasteController.text = waste.studentWaste?.toString() ?? '';
      milkWasteController.text = waste.coffeWaste?.toString() ?? '';
      for (final attendance in waste.attendances) {
        print(attendance);
        attendances[hostelIdMap[attendance.hostelId]!] =
            attendance.studentsAbsent;
      }
    } else {
      _clearControllers();
    }
  }

  void _handleDateAndTimingChange() async {
    if (timing == null) return;
    await ref
        .read(wasteManageNotifierProvider.notifier)
        .fetchWaste(selectedDate, timing!);
    _updateControllersFromWaste();
  }

  bool _isFutureDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    return selected.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    final baseInfo = ref.watch(authNotifierProvider).baseInfo;
    final wasteState = ref.watch(wasteManageNotifierProvider);

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (wasteState.isLoading) LoadingScreen(),
            Column(
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
                      if (!_isFutureDate(selectedDate))
                        CustomDropdownField<TimingModel>(
                          label: 'Select Meal Time',
                          hint: 'Choose a meal time',
                          items: baseInfo?.timings ?? [],
                          value: timing,
                          getLabel: (meal) => meal.name,
                          onChanged: baseInfo?.timings != null
                              ? (val) {
                                  setState(() {
                                    timing = val;
                                  });
                                  _handleDateAndTimingChange();
                                }
                              : null,
                        ),
                      if (wasteState.isFetching)
                        LoadingScreen()
                      else if (_isFutureDate(selectedDate))
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ResponsiveText(
                                  'That\’s too far ahead!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ResponsiveText(
                                  'Try selecting a recent date.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (timing != null)
                        Column(
                          children: [
                            if (wasteState.waste?.createdBy != null)
                              Align(
                                alignment: AlignmentGeometry.topLeft,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black54),
                                  'Last updated by ${wasteState.waste?.updatedBy}',
                                ),
                              ),
                            StudentCountSection(
                              hostels: widget.kitchen.hostels,
                              absentCounts: attendances,
                            ),
                            WasteSection(
                              coffeeWasteController: coffeeWasteController,
                              selectedTiming: timing,
                              studentWasteController: studentWasteController,
                              cookedWasteController: cookedWasteController,
                              milkWasteController: milkWasteController,
                            ),
                            PrimaryButton(
                              text: 'Save',
                              onPressed:
                                  (timing != null && !wasteState.isCreating)
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
          ],
        ),
      ),
    );
  }
}
