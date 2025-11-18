import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/date_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/date_selector.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/waste_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/student_count_selection.dart';
import 'package:hostel_app/features/waste/model/waste_create.dart';
import 'package:hostel_app/features/shared/models/kitchen/kitchen_model.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';

class WasteManageScreen extends ConsumerStatefulWidget {
  final KitchenModel kitchen;
  const WasteManageScreen({super.key, required this.kitchen});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  DateTime selectedDate = DateTime.now();
  Map<HostelModel, AttendanceValues> attendances = {};
  TimingModel? timing;
  Map<int, HostelModel> hostelMap = {};

  final coffeeCtrl = TextEditingController();
  final studentCtrl = TextEditingController();
  final cookedCtrl = TextEditingController();
  final milkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (final h in widget.kitchen.hostels) {
      hostelMap[h.id] = h;
      attendances[h] = AttendanceValues(present: h.studentsCount, absent: 0);
    }
  }

  bool _isOld(DateTime d) {
    final today = DateTime.now();
    final diff = today.difference(DateTime(d.year, d.month, d.day)).inDays;
    return diff > 2;
  }

  void _loadWaste() async {
    if (timing == null) return;
    final notifier = ref.read(wasteManageNotifierProvider.notifier);
    await notifier.fetchWaste(selectedDate, timing!);
    final state = ref.read(wasteManageNotifierProvider);

    if (state.waste == null) {
      // no data
      for (final h in widget.kitchen.hostels) {
        attendances[h] = AttendanceValues(present: h.studentsCount, absent: 0);
      }
      coffeeCtrl.clear();
      cookedCtrl.clear();
      studentCtrl.clear();
      milkCtrl.clear();
      setState(() {});
      return;
    }

    final w = state.waste!;
    cookedCtrl.text = w.foodCookedWaste?.toString() ?? "";
    studentCtrl.text = w.studentWaste?.toString() ?? "";
    coffeeCtrl.text = w.coffeWaste?.toString() ?? "";

    attendances.clear();
    for (final a in w.attendances) {
      final hostel = hostelMap[a.hostelId]!;
      attendances[hostel] = AttendanceValues(
        present: a.studentsPresent,
        absent: a.studentsAbsent,
      );
    }

    for (final h in widget.kitchen.hostels) {
      attendances.putIfAbsent(
        h,
        () => AttendanceValues(present: h.studentsCount, absent: 0),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final baseInfo = ref.watch(authNotifierProvider).baseInfo;
    final wasteState = ref.watch(wasteManageNotifierProvider);
    final hasData = wasteState.waste != null;
    final isOld = _isOld(selectedDate);
    final editable = !isOld;

    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'FOOD', title2: 'MANAGEMENT'),
            ResponsiveSizedBox(height: 20),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  DateSection(
                    selectedDate: selectedDate,
                    onDateChanged: (d) {
                      setState(() {
                        selectedDate = d;
                        timing = null;
                      });
                    },
                  ),

                  DateSelector(
                    selectedDate: selectedDate,
                    onSelect: (d) {
                      setState(() {
                        selectedDate = d;
                        timing = null;
                      });
                    },
                  ),

                  if (!isOld)
                    CustomDropdownField<TimingModel>(
                      label: 'Select Meal Time',
                      hint: 'Choose a meal time',
                      items: baseInfo?.timings ?? [],
                      value: timing,
                      getLabel: (m) => m.name,
                      onChanged: (v) {
                        setState(() => timing = v);
                        _loadWaste();
                      },
                    ),

                  if (isOld && timing == null) const SizedBox(),

                  if (isOld && !hasData)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: const [
                          Text(
                            'Out of Date Selected',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cannot add or edit data for past dates.',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  else if (timing != null)
                    Column(
                      children: [
                        if (wasteState.waste?.updatedBy != null)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Last updated by: ${wasteState.waste?.updatedBy}',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),

                        StudentCountSection(
                          hostels: widget.kitchen.hostels,
                          attendances: attendances,
                          editable:
                              editable && hasData == false ||
                              editable && hasData == true,
                        ),

                        WasteSection(
                          coffeeWasteController: coffeeCtrl,
                          selectedTiming: timing,
                          studentWasteController: studentCtrl,
                          cookedWasteController: cookedCtrl,
                          milkWasteController: milkCtrl,
                          editable: editable && hasData,
                        ),

                        if (!isOld)
                          PrimaryButton(text: 'Save', onPressed: _save),
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

  void _save() {
    final notifier = ref.read(wasteManageNotifierProvider.notifier);
    final attendancePayload = attendances.entries
        .map(
          (e) => AttendanceCreateModel(
            hostelId: e.key.id,
            studentsAbsent: e.value.absent,
            studentsPresent: e.value.present,
          ),
        )
        .toList();

    final model = WasteCreateModel(
      kitchen: widget.kitchen.id,
      timing: timing!.id,
      coffeWaste: int.tryParse(coffeeCtrl.text),
      foodCookedWaste: int.tryParse(cookedCtrl.text),
      studentWaste: int.tryParse(studentCtrl.text),
      date: selectedDate,
      attendances: attendancePayload,
    );

    final wasteState = ref.read(wasteManageNotifierProvider);
    if (wasteState.waste == null) {
      notifier.addWaste(model);
    } else {
      notifier.updateWaste(wasteState.waste!.id, model);
    }
  }
}
