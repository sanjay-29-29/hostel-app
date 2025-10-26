import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/widgets/waste/student_count_card.dart';

class StudentCountSection extends StatefulWidget {
  /// Map of hostelName → totalStudents
  final Map<String, int> hostelTotals;

  const StudentCountSection({
    super.key,
    required this.hostelTotals,
  }) : assert(
          hostelTotals.length == 1 || hostelTotals.length == 2,
          'You can have only 1 or 2 hostels per kitchen.',
        );

  @override
  State<StudentCountSection> createState() => _StudentCountSectionState();
}

class _StudentCountSectionState extends State<StudentCountSection> {
  final Map<String, TextEditingController> presentControllers = {};
  final Map<String, int> absentCounts = {};

  int totalPresent = 0;
  int totalAbsent = 0;

  @override
  void initState() {
    super.initState();
    for (final hostelName in widget.hostelTotals.keys) {
      final controller = TextEditingController();
      controller.addListener(_recalculateTotals);
      presentControllers[hostelName] = controller;
      absentCounts[hostelName] = 0;
    }
  }

  @override
  void dispose() {
    for (final controller in presentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _recalculateTotals() {
    int totalPresentCalc = 0;
    int totalAbsentCalc = 0;

    for (final entry in widget.hostelTotals.entries) {
      final name = entry.key;
      final total = entry.value;
      final present = int.tryParse(presentControllers[name]!.text) ?? 0;

      final absent = (total - present).clamp(0, total);
      absentCounts[name] = absent;

      totalPresentCalc += present;
      totalAbsentCalc += absent;
    }

    setState(() {
      totalPresent = totalPresentCalc;
      totalAbsent = totalAbsentCalc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hostelEntries = widget.hostelTotals.entries.toList();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Student Attendance',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),

          // Hostel-wise fields
          Column(
            children: hostelEntries.map((entry) {
              final hostelName = entry.key;
              final total = entry.value;
              final absent = absentCounts[hostelName] ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Text(
                      hostelName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoBox('Total', total.toString()),
                        SizedBox(
                          width: 90,
                          child: StudentCountCard(
                            label: 'Present',
                            controller: presentControllers[hostelName]!,
                          ),
                        ),
                        _buildInfoBox('Absent', absent.toString()),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Overall summary
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChip('Total Present', totalPresent.toString()),
              const SizedBox(width: 10),
              _buildChip('Total Absent', totalAbsent.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )),
        Container(
          width: 60,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildChip(String label, String value) {
    return Chip(
      backgroundColor: ColorConstants.primaryColor,
      label: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
