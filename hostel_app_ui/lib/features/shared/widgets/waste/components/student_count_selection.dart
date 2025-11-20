import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/widgets/waste/student_count_card.dart';
import 'package:hostel_app/features/waste/presentation/waste_manage_screen.dart';

class StudentCountSection extends StatelessWidget {
  final List<HostelModel> hostels;
  final Map<HostelModel, AttendanceValues> attendances;
  final Map<int, TextEditingController> presentControllers;
  final int totalPresent, totalAbsent;

  StudentCountSection({
    required this.hostels,
    required this.attendances,
    required this.presentControllers,
    required this.totalPresent,
    required this.totalAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Student Attendance',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: hostels.map((h) {
              final a = attendances[h]!;
              final ctrl = presentControllers[h.id]!;

              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Text(
                      h.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _box('Total', h.studentsCount.toString()),
                        SizedBox(
                          width: 90,
                          child: StudentCountCard(
                            label: 'Present',
                            controller: ctrl,
                            enabled: true,
                          ),
                        ),
                        _box('Absent', a.absent.toString()),
                      ],
                    ),
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
          ),
        ],
      ),
    );
  }

  Widget _box(String label, String value) {
    return Column(
      children: [
        Text(label),
        Container(
          width: 60,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _chip(String label, String value) {
    return Chip(
      label: Text('$label: $value', style: TextStyle(color: Colors.white)),
      backgroundColor: ColorConstants.primaryColor,
    );
  }
}

// ============ waste_manage_screen.dart (UPDATED) ============

