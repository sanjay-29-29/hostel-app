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

class AttendanceValues {
  int present;
  int absent;
  AttendanceValues({required this.present, required this.absent});
}

class WasteManageScreen extends ConsumerStatefulWidget {
  final KitchenModel kitchen;
  const WasteManageScreen({super.key, required this.kitchen});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  Map<HostelModel, AttendanceValues> attendances = {};
  Map<int, HostelModel> hostelMap = {};
  Map<int, TextEditingController> presentControllers = {};
  Map<int, VoidCallback> listeners = {};
  int totalPresent = 0;
  int totalAbsent = 0;
  TimingModel? timing;
  DateTime selectedDate = DateTime.now();

  final coffeeCtrl = TextEditingController();
  final studentCtrl = TextEditingController();
  final cookedCtrl = TextEditingController();
  final milkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetAttendance();
    _initControllers();
    _recalculateTotals();
  }

  @override
  void dispose() {
    for (final controller in presentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetAttendance() {
    for (final h in widget.kitchen.hostels) {
      hostelMap[h.id] = h;
      attendances[h] = AttendanceValues(present: h.studentsCount, absent: 0);
    }
  }

  void _initControllers() {
    for (final hostel in widget.kitchen.hostels) {
      final ctrl = TextEditingController(
        text: attendances[hostel]!.present.toString(),
      );
      void l() => _onChanged(hostel, ctrl);
      ctrl.addListener(l);
      presentControllers[hostel.id] = ctrl;
      listeners[hostel.id] = l;
    }
  }

  void _onChanged(HostelModel hostel, TextEditingController controller) {
    final total = hostel.studentsCount;
    final p = int.tryParse(controller.text) ?? 0;
    final present = p.clamp(0, total);
    if (present != p) controller.text = present.toString();
    final absent = total - present;

    attendances[hostel] = AttendanceValues(present: present, absent: absent);
    _recalculateTotals();
  }

  void _recalculateTotals() {
    int tP = 0;
    int tA = 0;
    for (final h in widget.kitchen.hostels) {
      final a = attendances[h]!;
      tP += a.present;
      tA += a.absent;
    }
    setState(() {
      totalPresent = tP;
      totalAbsent = tA;
    });
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
      // no data - reset to defaults
      for (final h in widget.kitchen.hostels) {
        attendances[h] = AttendanceValues(present: h.studentsCount, absent: 0);
        // Update controllers
        final controller = presentControllers[h.id];
        if (controller != null) {
          controller.removeListener(listeners[h.id]!);
          controller.text = h.studentsCount.toString();
          controller.addListener(listeners[h.id]!);
        }
      }
      coffeeCtrl.clear();
      cookedCtrl.clear();
      studentCtrl.clear();
      milkCtrl.clear();
      _recalculateTotals();
      return;
    }

    final waste = state.waste!;
    cookedCtrl.text = waste.foodCookedWaste?.toString() ?? '';
    studentCtrl.text = waste.studentWaste?.toString() ?? '';
    coffeeCtrl.text = waste.coffeWaste?.toString() ?? '';

    attendances.clear();
    for (final attendance in waste.attendances) {
      final hostel = hostelMap[attendance.hostelId]!;
      attendances[hostel] = AttendanceValues(
        present: attendance.studentsPresent,
        absent: attendance.studentsAbsent,
      );

      final controller = presentControllers[hostel.id];
      if (controller != null) {
        controller.removeListener(listeners[hostel.id]!);
        controller.text = attendance.studentsPresent.toString();
        controller.addListener(listeners[hostel.id]!);
      }
    }

    for (final hostel in widget.kitchen.hostels) {
      attendances.putIfAbsent(
        hostel,
        () => AttendanceValues(present: hostel.studentsCount, absent: 0),
      );

      if (!presentControllers.containsKey(hostel.id)) {
        final ctrl = TextEditingController(
          text: hostel.studentsCount.toString(),
        );
        void l() => _onChanged(hostel, ctrl);
        ctrl.addListener(l);
        presentControllers[hostel.id] = ctrl;
        listeners[hostel.id] = l;
      }
    }

    _recalculateTotals();
    setState(() {});
  }

  void handleDateChange(DateTime d) {
    setState(() {
      selectedDate = d;
      timing = null;
    });
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
                    onDateChanged: handleDateChange,
                  ),
                  SizedBox(height: 24),
                  DateSelector(
                    selectedDate: selectedDate,
                    onSelect: handleDateChange,
                  ),
                  SizedBox(height: 24),
                  if (!wasteState.isFetching)
                    Column(
                      children: [
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
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
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
                                presentControllers: presentControllers,
                                totalAbsent: totalAbsent,
                                totalPresent: totalPresent,
                              ),
                              WasteSection(
                                coffeeWasteController: coffeeCtrl,
                                selectedTiming: timing,
                                studentWasteController: studentCtrl,
                                cookedWasteController: cookedCtrl,
                                milkWasteController: milkCtrl,
                                editable: true,
                              ),

                              if (!isOld)
                                PrimaryButton(text: 'Save', onPressed: _save),
                            ],
                          ),
                      ],
                    )
                  else
                    CircularProgressIndicator(),
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
    // TODO: handle update after create waste without changing date
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
