import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/widgets/waste/student_count_card.dart';

class AttendanceValues {
  int present;
  int absent;
  AttendanceValues({required this.present, required this.absent});
}

class StudentCountSection extends StatefulWidget {
  final List<HostelModel> hostels;
  final Map<HostelModel, AttendanceValues> attendances;
  final bool editable;

  const StudentCountSection({
    super.key,
    required this.hostels,
    required this.attendances,
    this.editable = true,
  });

  @override
  State<StudentCountSection> createState() => _StudentCountSectionState();
}

class _StudentCountSectionState extends State<StudentCountSection> {
  final Map<int, TextEditingController> presentControllers = {};
  final Map<int, VoidCallback> listeners = {};

  int totalPresent = 0;
  int totalAbsent = 0;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _recalculateTotals();
  }

  void _initControllers() {
    for (final hostel in widget.hostels) {
      final ctrl = TextEditingController(text: widget.attendances[hostel]!.present.toString());
      void l() => _onChanged(hostel, ctrl);
      ctrl.addListener(l);
      presentControllers[hostel.id] = ctrl;
      listeners[hostel.id] = l;
    }
  }

  void _onChanged(HostelModel hostel, TextEditingController controller) {
    if (!widget.editable) return;
    final total = hostel.studentsCount;
    final p = int.tryParse(controller.text) ?? 0;
    final present = p.clamp(0, total);
    if (present != p) controller.text = present.toString();
    final absent = total - present;

    widget.attendances[hostel] = AttendanceValues(present: present, absent: absent);
    _recalculateTotals();
  }

  void _recalculateTotals() {
    int tP = 0;
    int tA = 0;
    for (final h in widget.hostels) {
      final a = widget.attendances[h]!;
      tP += a.present;
      tA += a.absent;
    }
    setState(() {
      totalPresent = tP;
      totalAbsent = tA;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            decoration: BoxDecoration(color: ColorConstants.primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Text('Student Attendance', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 10),
          Column(
            children: widget.hostels.map((h) {
              final a = widget.attendances[h]!;
              final ctrl = presentControllers[h.id]!;

              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Text(h.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _box('Total', h.studentsCount.toString()),
                        SizedBox(
                          width: 90,
                          child: StudentCountCard(label: 'Present', controller: ctrl, enabled: widget.editable),
                        ),
                        _box('Absent', a.absent.toString()),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip('Total Present', totalPresent.toString()),
              SizedBox(width: 10),
              _chip('Total Absent', totalAbsent.toString()),
            ],
          )
        ],
      ),
    );
  }

  Widget _box(String label, String value) {
    return Column(children: [Text(label), Container(width: 60, padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black54)), child: Text(value))]);
  }

  Widget _chip(String label, String value) {
    return Chip(label: Text('$label: $value', style: TextStyle(color: Colors.white)), backgroundColor: ColorConstants.primaryColor);
  }
}

// ============ waste_manage_screen.dart (UPDATED) ============